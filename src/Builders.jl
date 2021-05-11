
function build_js_string(options::Options, swagger_doc::Union{Dict{String, Any}, Nothing})::String
    swagger_options = _options_to_json(options, swagger_doc)
    return """
        window.onload = function() {
            let url = window.location.search.match(/url=([^&]+)/);
            if (url && url.length > 1) {
                url = decodeURIComponent(url[1]);
            } else {
                url = window.location.origin;
            }
            const options = $(swagger_options)
            url = options.swaggerUrl || url
            const customOptions = options.customOptions
            const swaggerOptions = {
                spec: options.swaggerDoc,
                url: url,
                urls: options.swaggerUrls,
                dom_id: '#swagger-ui',
                deepLinking: true,
                presets: [
                    SwaggerUIBundle.presets.apis,
                    SwaggerUIStandalonePreset
                ],
                plugins: [
                    SwaggerUIBundle.plugins.DownloadUrl
                ],
                layout: "StandaloneLayout"
            }

            for (const attr in customOptions) {
                swaggerOptions[attr] = customOptions[attr]
            }

            const ui = SwaggerUIBundle(swaggerOptions);
            
            if (customOptions.oauth) {
                ui.initOAuth(customOptions.oauth)
            }

            if (customOptions.authAction) {
                ui.authActions.authorize(customOptions.authAction)
            }
        
            window.ui = ui;
        };
    """
end

function build_html_string(options::Options, js_string::String)::String
    favicon = options.custom_favicon == "" ? DEFAULT_FAVICON : "<link rel='icon' href=$(options.custom_favicon) />"
    title = options.custom_site_title
    style = options.custom_css
    stylesheet = options.custom_css_url == "" ? "" : "<link rel='stylesheet' type='text/css' href=$(options.custom_css_url) />"
    script = options.custom_js == "" ? "" : "<script src=$(options.custom_js) charset='UTF-8'></script>"
    explorer = options.show_explorer ? "" : ".swagger-ui .topbar .download-url-wrapper { display: none; }"
    return """
        <!-- HTML for static distribution bundle build -->
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <title>$(title)</title>
            <link rel="stylesheet" type="text/css" href="./swagger-ui.css" />
            $(favicon)
            $(script)
            <style>
                html
                {
                    box-sizing: border-box;
                    overflow: -moz-scrollbars-vertical;
                    overflow-y: scroll;
                }

                *,
                *:before,
                *:after
                {
                    box-sizing: inherit;
                }

                body
                {
                    margin:0;
                    background: #fafafa;
                }

                $(explorer)
                $(style)
            </style>
        </head>
        <body>
            <div id="swagger-ui"></div>
            <script src="./swagger-ui-bundle.js" charset="UTF-8"></script>
            <script src="./swagger-ui-standalone-preset.js" charset="UTF-8"></script>
            <script>$(js_string)</script>
            $(stylesheet)
        </body>
        </html>
    """
end