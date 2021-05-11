using Genie, Genie.Router
using Genie.Renderer, Genie.Renderer.Html, Genie.Renderer.Json

swagger_document = JSON.parsefile("./swagger.json")
swagger_options = Dict{String, Any}()
swagger_options["validatorUrl"] = nothing
# swagger_options["url"] = "https://petstore.swagger.io/v2/swagger.json"
# options = Options(show_explorer=false, swagger_options=swagger_options)

# options.custom_css = ".swagger-ui .topbar { display: none }"

urls = Array{Dict{String, Any}, 1}()
url1 = Dict{String, Any}()
url1["url"] = "https://petstore.swagger.io/v2/swagger.json"
url1["name"] = "Spec1"
url2 = Dict{String, Any}()
url2["url"] = "https://petstore.swagger.io/v2/swagger.json"
url2["name"] = "Spec2"
push!(urls, url1)
push!(urls, url2)

swagger_options["urls"] = urls

options = Options(swagger_options=swagger_options)

route("/") do 
    render_swagger(nothing, options=options)
    # render_swagger(swagger_document, options=options)
end

up(8001, async = false)