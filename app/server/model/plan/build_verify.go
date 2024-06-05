package plan

import (
	"fmt"
	"log"
	"plandex-server/model"
	"plandex-server/model/prompts"

	"github.com/sashabaranov/go-openai"
)

func (fileState *activeBuildStreamFileState) verifyFileBuild() {
	filePath := fileState.filePath
	planId := fileState.plan.Id
	branch := fileState.branch
	clients := fileState.clients
	config := fileState.settings.ModelPack.GetVerifier()
	updated := fileState.activeBuild.ToVerifyUpdatedState

	activePlan := GetActivePlan(planId, branch)

	if activePlan == nil {
		log.Printf("Active plan not found for plan ID %s and branch %s\n", planId, branch)
		return
	}

	log.Printf("verifyFileBuild - Verifying file %s\n", filePath)

	// log.Println("File context:", fileContext)

	// log.Printf("preBuildState has content: %v\n", preBuildState != "")
	// log.Printf("updated has content: %v\n", updated != "")
	// log.Printf("activeBuild.FileDescription has content: %v\n", activeBuild.FileDescription != "")
	// log.Printf("activeBuild.FileContent has content: %v\n", activeBuild.FileContent != "")

	verifyState, err := fileState.GetVerifyState()

	if err != nil {
		log.Printf("Error getting verify state for file '%s': %v\n", filePath, err)
		fileState.onBuildFileError(fmt.Errorf("error getting verify state for file '%s': %v", filePath, err))
		return
	}

	if verifyState == nil {
		log.Printf("verifyFileBuild - Verify state not found for file '%s'\n", filePath)
		log.Println("finishing file build")
		fileState.onFinishBuildFile(nil, "")
		return
	}

	sysPrompt := prompts.GetVerifyPrompt(verifyState.preBuildFileState, updated,
		verifyState.proposedChanges,
	)

	// log.Println("verify sysPrompt:\n", sysPrompt)

	fileMessages := []openai.ChatCompletionMessage{
		{
			Role:    openai.ChatMessageRoleSystem,
			Content: sysPrompt,
		},
	}

	log.Println("verifyFileBuild - Calling verify model for file: " + filePath)

	// for _, msg := range fileMessages {
	// 	log.Printf("%s: %s\n", msg.Role, msg.Content)
	// }

	var responseFormat *openai.ChatCompletionResponseFormat
	if config.BaseModelConfig.HasJsonResponseMode {
		responseFormat = &openai.ChatCompletionResponseFormat{Type: "json_object"}
	}

	modelReq := openai.ChatCompletionRequest{
		Model: config.BaseModelConfig.ModelName,
		Tools: []openai.Tool{
			{
				Type:     "function",
				Function: &prompts.VerifyOutputFn,
			},
		},
		ToolChoice: openai.ToolChoice{
			Type: "function",
			Function: openai.ToolFunction{
				Name: prompts.VerifyOutputFn.Name,
			},
		},
		Messages:       fileMessages,
		Temperature:    config.Temperature,
		TopP:           config.TopP,
		ResponseFormat: responseFormat,
	}

	envVar := config.BaseModelConfig.ApiKeyEnvVar
	client := clients[envVar]

	stream, err := model.CreateChatCompletionStreamWithRetries(client, activePlan.Ctx, modelReq)
	if err != nil {
		log.Printf("Error creating plan file stream for path '%s': %v\n", filePath, err)
		fileState.onBuildFileError(fmt.Errorf("error creating plan file stream for path '%s': %v", filePath, err))
		return
	}

	go fileState.listenStreamVerifyOutput(stream)

}
