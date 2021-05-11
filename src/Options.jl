const DEFAULT_FAVICON = "<link rel='icon' type='image/png' href='./favicon-16x16.png' sizes='16x16' /><link rel='icon' type='image/png' href='./favicon-32x32.png' sizes='32x32' />"
const DEFAULT_TITLE = "Swagger UI"

mutable struct Options
    show_explorer::Bool
    custom_js::String
    custom_css::String
    custom_css_url::String
    custom_site_title::String
    custom_favicon::String
    swagger_options::Dict{String, Any}

    function Options(;
        show_explorer::Bool=true, 
        custom_js::String="", 
        custom_css::String="", 
        custom_css_url::String="", 
        custom_site_title::String=DEFAULT_TITLE, 
        custom_favicon::String="", 
        swagger_options::Dict{String, Any}=Dict{String, Any}())

        this = new()
        this.show_explorer = show_explorer
        this.custom_js = custom_js
        this.custom_css = custom_css
        this.custom_css_url = custom_css_url
        this.custom_site_title = custom_site_title
        this.custom_favicon = custom_favicon
        this.swagger_options = swagger_options
        return this
    end
end

function _options_to_json(options::Options, swagger_doc::Union{Dict{String, Any}, Nothing})::String
    swagger_options = options.swagger_options
    opts = Dict{String, Any}()
    opts["customOptions"] = swagger_options
    if !isnothing(swagger_doc)
        opts["swaggerDoc"] = swagger_doc
    end
    if haskey(swagger_options, "swaggerUrl")
        opts["swaggerUrl"] = swagger_options["swaggerUrl"]
    end
    if haskey(swagger_options, "swaggerUrls")
        opts["swaggerUrls"] = swagger_options["swaggerUrls"]
    end
    return JSON.json(opts)
end