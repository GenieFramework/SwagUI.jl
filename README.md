# Julia Swagger UI
[![codecov](https://codecov.io/gh/jiachengzhang1/SwaggerUI/branch/master/graph/badge.svg?token=H88TK4G1NY)](https://codecov.io/gh/jiachengzhang1/SwaggerUI)

Want to use [Swagger UI](https://swagger.io/tools/swagger-ui/) in Julia? This package has your back!

Inspired by [swagger-ui-express](https://github.com/scottie1984/swagger-ui-express), the package auto-generates Swagger UI based on `swagger.json`. The generated API documentation can be served as an endpoint using package such as [Genie.jl](https://github.com/GenieFramework/Genie.jl).

Pre-built [swagger-ui](https://github.com/swagger-api/swagger-ui/tree/master/dist) is used. Because swagger-ui is implemented in Node.js, all pre-built files and assets are included in the [dist](dist) folder for serving. (Open an issue if there are better ways to do this.)

## Installation

```julia
julia> ]
pkg> add SwagUI
```
## Usage

Genie simple setup

```julia
using Genie, Genie.Router
using JSON
using SwagUI

# use a swagger json from the local machine
swagger_document = JSON.parsefile("./swagger.json")

route("/docs") do 
    render_swagger(swagger_document)
end
```

### Inegrate with [Swagger Markdown](https://github.com/GenieFramework/SwaggerMarkdown.jl)

```julia
using Genie, Genie.Router
using JSON
using SwagUI
using SwaggerMarkdown

@swagger """
/doge:
  get:
    description: Doge to the moon!
    responses:
      '200':
        description: Doge to the moon!!.
"""
route("/doge") do 
    JSON.json("Doge to the moon!!")
end

# build a swagger document from markdown
info = Dict{String, Any}()
info["title"] = "Swagger Petstore"
info["version"] = "1.0.5"
openApi = OpenAPI("2.0", info)
swagger_document = build(openApi)

route("/docs") do 
    render_swagger(swagger_document)
end

up(8001, async = false)
```

[SwaggerMarkdown](https://github.com/jiachengzhang1/SwaggerMarkdown) builds the swagger document from markdown comments in the code. It returns a `swagger_document::Dict{String, Any}` that can be used by `SwaggerUI.render_swagger` to render the API documentation as Swagger's fashion.


### Configuration & Customization

**Swagger Explorer**

The explorer can be turned off through setting the `Options.show_explorer` to `false`. It's turned on, i.e. `Options.show_explorer = true` by default.

```julia
using Genie, Genie.Router
using JSON
using SwagUI

swagger_document = JSON.parsefile("./swagger.json")

# turn off the explorer
options = Options()
options.show_explorer = false

route("/docs") do 
    render_swagger(swagger_document, options=options)
end
```

**Custom swagger options**

Swagger UI can be configured by setting `Options.swagger_options::Dict{String, Any}`. The key is the name of the configuration while the value is the setting. More details about configuration can be found through the [Official Swagger UI Configuration page](https://github.com/swagger-api/swagger-ui/blob/master/docs/usage/configuration.md). The example below sets the URL pointing to API definition to `https://petstore.swagger.io/v2/swagger.json`.

```julia
using Genie, Genie.Router
using JSON
using SwagUI

# set the URL pointing to API definition
options = Options()
options.swagger_options["url"] = "https://petstore.swagger.io/v2/swagger.json"

route("/docs") do 
    # if swagger_options["url"] or swagger_options["urls"] is set,
    # swagger_document is not needed
    render_swagger(nothing, options=options)
end
```

**Custom CSS**

Set `Options.custom_css` to a custom CSS as `String`.

```julia
using Genie, Genie.Router
using JSON
using SwagUI

swagger_document = JSON.parsefile("./swagger.json")

# set custom css using options
options = Options()
options.custom_css = ".swagger-ui .topbar { display: none }"

route("/docs") do 
    render_swagger(swagger_document, options=options)
end
```

**TODO** 

More examples

