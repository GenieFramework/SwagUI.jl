using JSON
using Genie, HTTP
using Genie.Router, Genie.Responses

const PORT = 8000
const HOST = "127.0.0.1"
const PROTOCAL = "http"
const BASE_URL = "$PROTOCAL://$HOST:$PORT"
const ASSETS_PATH = joinpath(dirname(dirname(@__FILE__)), "test", "assets")
const DEFAULT_SWAGGER_JSON = "https://petstore.swagger.io/v2/swagger.json"

function serve_assets(path::String; excludes::Array{String, 1}=Array{String, 1}())
    for (root, _, files) in walkdir(path)
        for file in files
            if !(file in excludes)
                route(file) do 
                    serve_static_file(file, root=root)
                end
            end
        end
    end
end

serve_assets(ASSETS_PATH)
Genie.AppServer.startup(PORT, HOST; open_browser = false, verbose = true)

# basic settings
swagger_document = JSON.parsefile(joinpath(ASSETS_PATH, "swagger.json"))
swagger_options = Dict{String, Any}()
options = Options()

swagger_options["url"] = "https://petstore.swagger.io/v2/swagger.json"
options.swagger_options = swagger_options

@testset "Render Assets Tests" begin
    for (root, dirs, files) in walkdir(ASSETS_PATH)
        for file in files
            r = HTTP.request("GET", "$BASE_URL/$file")
            local_file = read(open(joinpath(ASSETS_PATH, file)), String)
            @test r.status == 200
            @test local_file == String(r.body)
        end
    end
end

@testset "Basic Swagger Tests" begin
    route_name = "docs"
    route("/$route_name", method = GET) do
        render_swagger(nothing, options=options)
    end

    r = HTTP.request("GET", "$BASE_URL/$route_name")
    html_string = String(r.body)
    opts = Dict{String, Any}()
    opts["customOptions"] = swagger_options

    @test r.status == 200
    @test occursin("<title>$(options.custom_site_title)</title>", html_string)
    @test occursin("const options = $(JSON.json(opts))", html_string)
end

@testset "Customizations Tests" begin
    route_name = "docs_custom"
    custom_options = Options()
    custom_swagger_options = Dict{String, Any}()
    custom_swagger_options["url"] = DEFAULT_SWAGGER_JSON
    custom_options.swagger_options = custom_swagger_options

    # custom css
    css_string = ".swagger-ui .topbar { display: none }"
    custom_options.custom_css = css_string

    # custom stylesheet
    stylesheet_path = joinpath(ASSETS_PATH, "custom.css")
    custom_options.custom_css_url = stylesheet_path

    # custom favicon
    favicon_path = joinpath(ASSETS_PATH, "favicon.ico")
    custom_options.custom_favicon = favicon_path

    # custom site title
    title = "Jimmy's new API"
    custom_options.custom_site_title = title

    route("/$route_name", method = GET) do
        render_swagger(nothing, options=custom_options)
    end

    r = HTTP.request("GET", "$BASE_URL/$route_name")
    html_string = replace(String(r.body), "\n" => "")
    
    @test r.status == 200
    @test occursin(css_string, html_string)
    @test occursin("<link rel='stylesheet' type='text/css' href=$(stylesheet_path) />", html_string)
    @test occursin("<title>$(title)</title>", html_string)
    @test occursin("<link rel='icon' href=$(favicon_path) />", html_string)
end