package plan_exec

import (
	"gpt4cli-cli/types"
	shared "gpt4cli-shared"
)

type ExecParams struct {
	CurrentPlanId        string
	CurrentBranch        string
	AuthVars             map[string]string
	CheckOutdatedContext func(maybeContexts []*shared.Context, projectPaths *types.ProjectPaths) (bool, bool, error)
}

var PromptSyncModelsIfNeeded func() error

func SetPromptSyncModelsIfNeeded(fn func() error) {
	PromptSyncModelsIfNeeded = fn
}
