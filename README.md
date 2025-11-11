# biocTcgaMcp

Purpose: demo an MCP server with tools for TCGA analhsis

With this package installed and a suitable configuration file at `~/.config/mcptools/config.json`
that includes

```
{
  "mcpServers": {
    "r-mcptools": {
      "command": "Rscript",
      "args": ["-e", "mcptools::mcp_server()"]
    },
    "r-btw": {
      "command": "Rscript",
      "args": ["-e", "btw::btw_mcp_server()"]
    },
    "r-tcga": {
      "command": "Rscript",
      "args": ["-e", "biocTcgaMcp::btcga_mcp_server()"]
    }
  }
}
```

then

```
library(ellmer)
ch = chat_openai(model="gpt-4o")
ch$set_tools(mcptools::mcp_tools())  # need biocTcgaMcp 0.0.2 for improved type list tool
cc = type_array(type_object(codes = type_string(description = "TCGA tumor type codes"), 
         types = type_string(description = "TCGA tumor study names"))
ch$chat_structured("What tumor types are available in TCGA?", type=cc)
```
should return a data.frame.  `chat_structured` is not necessary but creates
a value in the calling R session.

```
> ch$chat_structured("What tumor types are available in TCGA?", type=cc)
   codes                                                            types
1    ACC                                         Adrenocortical carcinoma
2   BLCA                                     Bladder Urothelial Carcinoma
3   BRCA                                        Breast invasive carcinoma
4   CESC Cervical squamous cell carcinoma and endocervical adenocarcinoma
5   CHOL                                               Cholangiocarcinoma
6   COAD                                             Colon adenocarcinoma
7   DLBC                  Lymphoid Neoplasm Diffuse Large B-cell Lymphoma
8   ESCA                                             Esophageal carcinoma
9    GBM                                          Glioblastoma multiforme
10  HNSC                            Head and Neck squamous cell carcinoma
11  KICH                                               Kidney Chromophobe
12  KIRC                                Kidney renal clear cell carcinoma
13  KIRP                            Kidney renal papillary cell carcinoma
14  LAML                                           Acute Myeloid Leukemia
15   LGG                                         Brain Lower Grade Glioma
16  LIHC                                   Liver hepatocellular carcinoma
17  LUAD                                              Lung adenocarcinoma
18  LUSC                                     Lung squamous cell carcinoma
19  MESO                                                     Mesothelioma
20    OV                                Ovarian serous cystadenocarcinoma
21  PAAD                                        Pancreatic adenocarcinoma
22  PCPG                               Pheochromocytoma and Paraganglioma
23  PRAD                                          Prostate adenocarcinoma
24  READ                                            Rectum adenocarcinoma
25  SARC                                                          Sarcoma
26  SKCM                                          Skin Cutaneous Melanoma
27  STAD                                           Stomach adenocarcinoma
28  TGCT                                      Testicular Germ Cell Tumors
29  THCA                                                Thyroid carcinoma
30  THYM                                                          Thymoma
31  UCEC                             Uterine Corpus Endometrial Carcinoma
32   UCS                                           Uterine Carcinosarcoma
33   UVM                                                   Uveal Melanoma
```

The tool defined in this package that should be used to answer the query above can
be run directly with `biocTcgaMcp::list_cancer_types()` and returns a data.frame with
33 rows.

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


