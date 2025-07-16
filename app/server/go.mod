module gpt4cli-server

go 1.23.3

require (
	github.com/davecgh/go-spew v1.1.1
	github.com/google/uuid v1.6.0
	github.com/gorilla/mux v1.8.1
	github.com/pkg/errors v0.9.1
	github.com/sashabaranov/go-openai v1.40.5
	gpt4cli-shared v0.0.0-00010101000000-000000000000
)

require (
	git.sr.ht/~jackmordaunt/go-toast v1.1.2 // indirect
	github.com/dlclark/regexp2 v1.11.5 // indirect
	github.com/esiqveland/notify v0.13.3 // indirect
	github.com/go-ole/go-ole v1.3.0 // indirect
	github.com/godbus/dbus/v5 v5.1.0 // indirect
	github.com/google/go-cmp v0.7.0 // indirect
	github.com/hashicorp/errwrap v1.1.0 // indirect
	github.com/hashicorp/go-multierror v1.1.1 // indirect
	github.com/jackmordaunt/icns/v3 v3.0.1 // indirect
	github.com/jinzhu/copier v0.4.0 // indirect
	github.com/jmespath/go-jmespath v0.4.0 // indirect
	github.com/mattn/go-colorable v0.1.14 // indirect
	github.com/mattn/go-isatty v0.0.20 // indirect
	github.com/mattn/go-runewidth v0.0.16 // indirect
	github.com/nfnt/resize v0.0.0-20180221191011-83c6a9932646 // indirect
	github.com/olekukonko/errors v1.1.0 // indirect
	github.com/olekukonko/ll v0.0.9 // indirect
	github.com/olekukonko/tablewriter v1.0.8 // indirect
	github.com/pkoukk/tiktoken-go v0.1.7 // indirect
	github.com/pmezard/go-difflib v1.0.0 // indirect
	github.com/rivo/uniseg v0.4.7 // indirect
	github.com/sergeymakinen/go-bmp v1.0.0 // indirect
	github.com/sergeymakinen/go-ico v1.0.0-beta.0 // indirect
	github.com/shopspring/decimal v1.4.0 // indirect
	github.com/tadvi/systray v0.0.0-20190226123456-11a2b8fa57af // indirect
	go.uber.org/atomic v1.11.0 // indirect
	golang.org/x/image v0.29.0 // indirect
	golang.org/x/sys v0.34.0 // indirect
	gopkg.in/yaml.v3 v3.0.1 // indirect
)

require (
	github.com/atotto/clipboard v0.1.4
	github.com/aws/aws-sdk-go v1.55.7
	github.com/fatih/color v1.18.0
	github.com/gen2brain/beeep v0.11.1
	github.com/golang-migrate/migrate/v4 v4.18.3
	github.com/jmoiron/sqlx v1.4.0
	github.com/lib/pq v1.10.9
	github.com/smacker/go-tree-sitter v0.0.0-20240827094217-dd81d9e9be82
	github.com/stretchr/testify v1.10.0
	golang.org/x/mod v0.26.0
	golang.org/x/net v0.42.0
)

replace gpt4cli-shared => ../shared
