# biocTcgaMcp

demo an MCP server with tools for TCGA analhsis

With this package installed and a suitable configuration file at `~/.config/mcptools/config.json`
that includes

```
"r-tcga": {
      "command": "Rscript",
      "args": ["-e", "biocTcgaMcp::btcga_mcp_server()"]
    }
```

then

```
ch = chat_openai(model="gpt-4o")
ch$set_tools(mcptools::mcp_tools())
ch$chat_structured("What tumor types are available in TCGA?", type=biocTcgaMcp::cantypes_str())
```

should return a data.frame.  `chat_structured` is not necessary but provides
a data.frame result.

