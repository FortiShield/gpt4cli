package auth

import (
	"encoding/base64"
	"encoding/json"
	"fmt"
	"net/http"
	"gpt4cli/types"

	"github.com/gpt4cli/gpt4cli/shared"
)

var apiClient types.ApiClient

func SetApiClient(client types.ApiClient) {
	apiClient = client
}

func SetAuthHeader(req *http.Request) error {
	if Current == nil {
		return fmt.Errorf("error setting auth header: auth not loaded")
	}

	authHeader := shared.AuthHeader{
		Token: Current.Token,
		OrgId: Current.OrgId,
	}

	bytes, err := json.Marshal(authHeader)

	if err != nil {
		return fmt.Errorf("error marshalling auth header: %v", err)
	}

	// base64 encode
	token := base64.StdEncoding.EncodeToString(bytes)

	req.Header.Set("Authorization", "Bearer "+token)

	return nil
}
