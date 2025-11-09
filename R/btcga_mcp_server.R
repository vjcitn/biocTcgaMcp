
#' set up server
#' @export
btcga_mcp_server = function (tools = bioc_tcga_tools()) {
    tools <- btw:::flatten_and_check_tools(tools)
    mcptools::mcp_server(tools = tools)
}

