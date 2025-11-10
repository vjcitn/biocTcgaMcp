# biocTcgaMcp

Purpose: demo an MCP server with tools for TCGA analhsis

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
a data.frame result.  Note that the result from `chat_structured` can be quite
suboptimal.  See below.

The tool defined in this package that should be used to answer the query above can
be run directly with `biocTcgaMcp::list_cancer_types()` and returns a data.frame with
33 rows.

## Quality concerns

```
> ch = chat_openai(model="gpt-4o")
> ch$set_tools(mcptools::mcp_tools())
> ch$chat_structured("What tumor types are available in TCGA?", type=biocTcgaMcp::cantypes_str())

Replacing existing list_r_sessions tool.
Replacing existing select_r_session tool.
Replacing existing list_r_sessions tool.
Replacing existing select_r_session tool.
> ch$chat_structured("What tumor types are available in TCGA?", type=biocTcgaMcp::cantypes_str())
   codes                                 types
1   LUAD                   Lung adenocarcinoma
2   LUSC          Lung squamous cell carcinoma
3   BRCA             Breast invasive carcinoma
4    GBM               Glioblastoma multiforme
5   HNSC Head and neck squamous cell carcinoma
6   KIRC     Kidney renal clear cell carcinoma
7   KIRP Kidney renal papillary cell carcinoma
8   LIHC        Liver hepatocellular carcinoma
9     OV     Ovarian serous cystadenocarcinoma
10  PRAD               Prostate adenocarcinoma
11  READ                 Rectum adenocarcinoma
12  STAD                Stomach adenocarcinoma
13  THCA                     Thyroid carcinoma
14  COAD                  Colon adenocarcinoma
15  LUAD                   Lung adenocarcinoma
16  LUSC          Lung squamous cell carcinoma
                                                 subtypes
1                                                       -
2                                                       -
3                                                       -
4                                                       -
5                                                       -
6                                                       -
7                                                       -
8                                                       -
9                                                       -
10                                                      -
11                                                      -
12                                                      -
13                                                      -
14                                                      -
15 Classic, Proximal-inflammatory, Proximal-proliferative
16                 Basal, Classical, Secretory, Primitive
> 
> ch$chat("No, really what tumor types have been studied in TCGA?")
>> [tool call] list_cancer_types_df()
>> {"jsonrpc":"2.0","id":3,"result":{"content":[{"type":"text","text":"c(\"ACC\", \"BLCA\", \"BRCA\", \"CESC\", …
The TCGA (The Cancer Genome Atlas) project has studied the following tumor types:

1. ACC - Adrenocortical carcinoma
2. BLCA - Bladder Urothelial Carcinoma
3. BRCA - Breast invasive carcinoma
4. CESC - Cervical squamous cell carcinoma and endocervical adenocarcinoma
5. CHOL - Cholangiocarcinoma
6. COAD - Colon adenocarcinoma
7. DLBC - Lymphoid Neoplasm Diffuse Large B-cell Lymphoma
8. ESCA - Esophageal carcinoma
9. GBM - Glioblastoma multiforme
10. HNSC - Head and Neck squamous cell carcinoma
11. KICH - Kidney Chromophobe
12. KIRC - Kidney renal clear cell carcinoma
13. KIRP - Kidney renal papillary cell carcinoma
14. LAML - Acute Myeloid Leukemia
15. LGG - Brain Lower Grade Glioma
16. LIHC - Liver hepatocellular carcinoma
17. LUAD - Lung adenocarcinoma
18. LUSC - Lung squamous cell carcinoma
19. MESO - Mesothelioma
20. OV - Ovarian serous cystadenocarcinoma
21. PAAD - Pancreatic adenocarcinoma
22. PCPG - Pheochromocytoma and Paraganglioma
23. PRAD - Prostate adenocarcinoma
24. READ - Rectum adenocarcinoma
25. SARC - Sarcoma
26. SKCM - Skin Cutaneous Melanoma
27. STAD - Stomach adenocarcinoma
28. TGCT - Testicular Germ Cell Tumors
29. THCA - Thyroid carcinoma
30. THYM - Thymoma
31. UCEC - Uterine Corpus Endometrial Carcinoma
32. UCS - Uterine Carcinosarcoma
33. UVM - Uveal Melanoma

These tumor types represent a wide range of cancers that have been analyzed as part of the TCGA effort to understand 
cancer genomics.
```

## A non-MCP query result:

```
> ch = chat_openai(model="gpt-4o")
> ch$chat("What are the tumor types studied in TCGA?")
The Cancer Genome Atlas (TCGA) was a large-scale project aimed at cataloging genetic mutations responsible for 
different types of cancer using genome sequencing and bioinformatics. TCGA studied a wide variety of tumor types, 
including but not limited to:

1. **Breast Invasive Carcinoma (BRCA)**
2. **Lung Adenocarcinoma (LUAD)**
3. **Lung Squamous Cell Carcinoma (LUSC)**
4. **Prostate Adenocarcinoma (PRAD)**
5. **Kidney Renal Clear Cell Carcinoma (KIRC)**
6. **Thyroid Carcinoma (THCA)**
7. **Stomach Adenocarcinoma (STAD)**
8. **Liver Hepatocellular Carcinoma (LIHC)**
9. **Colorectal Adenocarcinoma (COADREAD)**
10. **Brain Lower Grade Glioma (LGG)**
11. **Glioblastoma Multiforme (GBM)**
12. **Ovarian Serous Cystadenocarcinoma (OV)**
13. **Pancreatic Adenocarcinoma (PAAD)**
14. **Bladder Urothelial Carcinoma (BLCA)**
15. **Head and Neck Squamous Cell Carcinoma (HNSC)**
16. **Uterine Corpus Endometrial Carcinoma (UCEC)**
17. **Skin Cutaneous Melanoma (SKCM)**
18. **Esophageal Carcinoma (ESCA)**
19. **Cervical Squamous Cell Carcinoma and Endocervical Adenocarcinoma (CESC)**
20. **Acute Myeloid Leukemia (LAML)**
21. **Kidney Renal Papillary Cell Carcinoma (KIRP)**
22. **Kidney Chromophobe (KICH)**
23. **Uveal Melanoma (UVM)**
24. **Mesothelioma (MESO)**
25. **Pheochromocytoma and Paraganglioma (PCPG)**
26. **Thymoma (THYM)**
27. **Adrenocortical Carcinoma (ACC)**
28. **Cholangiocarcinoma (CHOL)**

These tumor types were selected for their prevalence and mortality rates, as well as their scientific and clinical 
importance. The data collected from TCGA has been crucial in advancing the understanding of the genomic underpinnings 
of cancer.
```

That's not too satisfying because we know there are 33 tumor types.

The purpose of this package is to refine tool definition and prompt design so that we
have low risk of getting an error.


