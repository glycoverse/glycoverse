# Case Study: Glycoproteomics

This vignette walks you through a complete glycoproteomics analysis
using `glycoverse`. We’ll explore the full spectrum of glycoproteomics
data analysis, from data loading and preprocessing to statistical
analysis and visualization. We’ll also dive into advanced glycan
structure analysis, including motif quantification and derived trait
analysis. Ready to dive in? Let’s go!

**Heads up:** `glycoverse` is built on `tidy` principles throughout. If
you’re new to `tidyverse` data analysis, we highly recommend checking
out Hadley Wickham’s excellent [R for Data
Science](https://r4ds.hadley.nz). Trust us, it’s worth the investment!

Quick readiness check:

- What’s a `tibble`?
- How do you filter rows in a `tibble`?
- What’s the modern alternative to `for` loops?
- What’s the `%>%` operator? Do we still need it?
- What makes data “tidy”?

## TL;DR

In case you’re in a hurry…

``` r
# Load the packages
library(tidyverse)
library(glycoverse)

# Preprocess the data
clean_exp <- auto_clean(real_experiment)

# Perform PCA
pca_res <- gly_pca(clean_exp)
autoplot(pca_res)

# Perform differential expression analysis
limma_res <- gly_limma(clean_exp)
get_tidy_result(limma_res)

# Perform motif analysis
motifs <- c(
  lewis_by = "dHex(??-?)Hex(??-?)[dHex(??-?)]HexNAc(??-",
  lewis_ax = "Hex(??-?)[dHex(??-?)]HexNAc(??-",
  sia_lewis_ax = "NeuAc(??-?)Hex(??-?)[dHex(??-?)]HexNAc(??-"
)
motif_exp <- quantify_motifs(clean_exp, motifs)
motif_anova_res <- gly_anova(motif_exp)
get_tidy_result(motif_anova_res, "main_test")

# Perform derived trait analysis
trait_exp <- derive_traits(clean_exp)
trait_anova_res <- gly_anova(trait_exp)
get_tidy_result(trait_anova_res, "main_test")
```

## Loading the Packages

We first load the `tidyverse` package, as usual.

``` r
library(tidyverse)
#> ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
#> ✔ dplyr     1.1.4     ✔ readr     2.1.5
#> ✔ forcats   1.0.1     ✔ stringr   1.6.0
#> ✔ ggplot2   4.0.0     ✔ tibble    3.3.0
#> ✔ lubridate 1.9.4     ✔ tidyr     1.3.1
#> ✔ purrr     1.2.0     
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> ✖ dplyr::filter() masks stats::filter()
#> ✖ dplyr::lag()    masks stats::lag()
#> ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
```

Just like `tidyverse`, `glycoverse` is a meta-package that loads a
collection of specialized packages all at once.

``` r
library(glycoverse)
#> ── Attaching core glycoverse packages ────────────────────── glycoverse 0.1.3 ──
#> ✔ glyclean 0.8.1      ✔ glyparse 0.5.3 
#> ✔ glydet   0.6.5      ✔ glyread  0.8.2 
#> ✔ glyenzy  0.4.1      ✔ glyrepr  0.7.5 
#> ✔ glyexp   0.10.1     ✔ glystats 0.5.3 
#> ✔ glymotif 0.11.2     ✔ glyvis   0.4.0 
#> ── Conflicts ───────────────────────────────────────── glycoverse_conflicts() ──
#> ✖ glyclean::aggregate()  masks stats::aggregate()
#> ✖ dplyr::filter()        masks stats::filter()
#> ✖ lubridate::intersect() masks dplyr::intersect(), base::intersect()
#> ✖ dplyr::lag()           masks stats::lag()
#> ✖ glyexp::select_var()   masks dplyr::select_var()
#> ✖ lubridate::setdiff()   masks dplyr::setdiff(), base::setdiff()
#> ✖ dplyr::setequal()      masks base::setequal()
#> ✖ lubridate::union()     masks dplyr::union(), base::union()
#> ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
```

## Reading the Data

Data import is typically your first step in any analysis. For this
tutorial, we’ll use the `real_experiment` dataset that comes with
`glyexp`. This is a real-world N-glycoproteomics dataset from 12
patients across four liver conditions: healthy controls (H), hepatitis
(M), cirrhosis (Y), and hepatocellular carcinoma (C), with 3 samples per
condition.

``` r
real_experiment
#> 
#> ── Glycoproteomics Experiment ──────────────────────────────────────────────────
#> ℹ Expression matrix: 12 samples, 4262 variables
#> ℹ Sample information fields: group <fct>
#> ℹ Variable information fields: peptide <chr>, peptide_site <int>, protein <chr>, protein_site <int>, gene <chr>, glycan_composition <comp>, glycan_structure <struct>
```

For your own projects, the `glyread` package can import data from
virtually any mainstream glycoproteomics software—pGlyco3,
MSFragger-Glyco, Byonic, you name it. Each software has its own
dedicated import function. For instance, data from pGlyco3 with
pGlycoQuant quantification can be loaded using
`read_pglyco3_pglycoquant()`. Check out [Get Started with
glyread](https://glycoverse.github.io/glyread/articles/glyread.html) for
the full rundown.

The `real_experiment` object (like all outputs from `glyread` functions)
is an `experiment()` object. If you’ve worked with
`SummarizedExperiment` from Bioconductor, think of `experiment()` as its
tidy cousin. Essentially, it’s a smart data container that manages three
key components:

- **Expression matrix**: quantitative data with samples as columns and
  variables as rows
- **Sample information**: a tibble with sample metadata (group, batch,
  demographics, etc.)
- **Variable information**: a tibble with feature metadata (proteins,
  peptides, glycan compositions, etc.)

You can get these data components by using `get_expr_mat()`,
`get_sample_info()`, and `get_var_info()`.

``` r
get_expr_mat(real_experiment)[1:5, 1:5]
#>             C1         C2           C3           H1         H2
#> GP1         NA         NA     10655.62 3.105412e+04         NA
#> GP2  414080036  609889761  78954431.49           NA   11724908
#> GP3  581723113  604842244 167889901.32 6.977076e+08  703566323
#> GP4 3299649335 2856490652 957651065.86 2.600523e+09 3229968280
#> GP5   30427048   34294394   6390129.81 5.159133e+07   37479075
```

``` r
get_sample_info(real_experiment)
#> # A tibble: 12 × 2
#>    sample group
#>    <chr>  <fct>
#>  1 C1     C    
#>  2 C2     C    
#>  3 C3     C    
#>  4 H1     H    
#>  5 H2     H    
#>  6 H3     H    
#>  7 M1     M    
#>  8 M2     M    
#>  9 M3     M    
#> 10 Y1     Y    
#> 11 Y2     Y    
#> 12 Y3     Y
```

``` r
get_var_info(real_experiment)
#> # A tibble: 4,262 × 8
#>    variable peptide   peptide_site protein protein_site gene  glycan_composition
#>    <chr>    <chr>            <int> <chr>          <int> <chr> <comp>            
#>  1 GP1      JKTQGK               1 P08185           176 SERP… Hex(5)HexNAc(4)Ne…
#>  2 GP2      HSHNJJSS…            5 P04196           344 HRG   Hex(5)HexNAc(4)Ne…
#>  3 GP3      HSHNJJSS…            5 P04196           344 HRG   Hex(5)HexNAc(4)   
#>  4 GP4      HSHNJJSS…            5 P04196           344 HRG   Hex(5)HexNAc(4)Ne…
#>  5 GP5      HJSTGCLR             2 P10909           291 CLU   Hex(6)HexNAc(5)   
#>  6 GP6      HSHNJJSS…            5 P04196           344 HRG   Hex(5)HexNAc(4)Ne…
#>  7 GP7      HSHNJJSS…            6 P04196           345 HRG   Hex(5)HexNAc(4)   
#>  8 GP8      HSHNJJSS…            5 P04196           344 HRG   Hex(5)HexNAc(4)dH…
#>  9 GP9      HSHNJJSS…            5 P04196           344 HRG   Hex(4)HexNAc(3)   
#> 10 GP10     HSHNJJSS…            5 P04196           344 HRG   Hex(4)HexNAc(4)Ne…
#> # ℹ 4,252 more rows
#> # ℹ 1 more variable: glycan_structure <struct>
```

For a deeper dive into `experiment()` objects, check out [Get Started
with glyexp](https://glycoverse.github.io/glyexp/articles/glyexp.html).

## Data Preprocessing

Raw quantification data needs preprocessing before analysis—that’s just
a fact of life in omics. Typical steps include normalization, missing
value imputation, and batch effect correction. Rather than making you
implement these tedious steps manually, `glyclean` provides a
comprehensive preprocessing pipeline. Just call `auto_clean()` on your
`experiment()` object and you’re good to go.

``` r
clean_exp <- auto_clean(real_experiment)
#> ℹ Normalizing data (Median)
#> ✔ Normalizing data (Median) [144ms]
#> 
#> ℹ Removing variables with >50% missing values
#> ✔ Removing variables with >50% missing values [23ms]
#> 
#> ℹ Imputing missing values
#> ℹ Sample size <= 30, using sample minimum imputation
#> ℹ Imputing missing values✔ Imputing missing values [32ms]
#> 
#> ℹ Aggregating data
#> ✔ Aggregating data [1s]
#> 
#> ℹ Normalizing data again
#> ✔ Normalizing data again [17ms]
```

Your data is now analysis-ready!

Want to customize the preprocessing steps? See [Get Started with
glyclean](https://glycoverse.github.io/glyclean/articles/glyclean.html)
for the full toolkit.

## Statistical Analysis and Visualization

Time for the fun part—statistical analysis and visualization! We’ll use
`glystats` for the number crunching and `glyvis` to make sense of the
results visually.

Let’s kick off with PCA to get a bird’s-eye view of our data structure.

``` r
plot_pca(clean_exp)  # from `glyvis`
```

![](case-study-1_files/figure-html/unnamed-chunk-9-1.png)

`glyvis` isn’t designed for publication-ready figures, but it’s perfect
for quick exploratory visualization. Behind the scenes, `plot_pca()`
calls `gly_pca()` from `glystats` and renders the results.

You can also break this down into separate steps:

``` r
pca_res <- gly_pca(clean_exp)  # from `glystats`
autoplot(pca_res)  # from `glyvis`
```

![](case-study-1_files/figure-html/unnamed-chunk-10-1.png)

We actually recommend the two-step approach, since it gives you more
flexibility with the results. You can create custom `ggplot2`
visualizations for publications or extract the underlying data when
reviewers ask for it.

`glystats` covers virtually all standard omics analyses. All functions
follow the same naming pattern: `gly_xxx()`—think `gly_anova()`,
`gly_ttest()`, `gly_roc()`, `gly_cox()`, `gly_wgcna()`, and so on. They
all take an `experiment()` object as their first argument.

The return format is consistent across all functions—a list with two
components:

- **`tidy_result`**: cleaned-up tibbles in tidy format. We’ve done the
  heavy lifting of organizing messy statistical output for you.
- **`raw_result`**: the original statistical objects. These are
  available when you need to dig deeper or perform advanced analyses.

`glystats` provides two helper functions to get the tidy result tibble
and the raw result list from a glystats result object:
`get_tidy_result()` and `get_raw_result()`. Let’s now see what the
`samples` tibble looks like:

``` r
get_tidy_result(pca_res, "samples")  # many tibbles, so we specify one of them
#> # A tibble: 144 × 4
#>    sample    PC   value group
#>    <chr>  <dbl>   <dbl> <fct>
#>  1 C1         1 -21.3   C    
#>  2 C1         2  24.1   C    
#>  3 C1         3   0.965 C    
#>  4 C1         4   1.89  C    
#>  5 C1         5 -11.2   C    
#>  6 C1         6  25.8   C    
#>  7 C1         7  -6.01  C    
#>  8 C1         8  -5.10  C    
#>  9 C1         9  27.8   C    
#> 10 C1        10  -7.09  C    
#> # ℹ 134 more rows
```

Notice the “group” column? That’s `glystats` being helpful— it
automatically pulls relevant metadata from your `experiment()` object
and includes it in the results wherever it makes sense.

Back to that
[`autoplot()`](https://ggplot2.tidyverse.org/reference/autoplot.html)
magic we saw earlier. It automatically recognizes different `glystats`
result types and plots accordingly— no manual specification needed. The
plots won’t win any beauty contests, but they’ll get your data insights
across fast.

The PCA clearly shows that our samples cluster nicely by
condition—always a good sign! Now let’s dive into differential
expression analysis using the tried-and-true `limma` package.

``` r
limma_res <- gly_limma(clean_exp, contrasts = "H_vs_C")  # from `glystats`
#> ℹ Number of groups: 4
#> ℹ Groups: "H", "M", "Y", and "C"
#> ℹ Pairwise comparisons will be performed, with levels coming first as reference groups.
#> ℹ Performing multi-group limma analysis with 4 groups
get_tidy_result(limma_res)  # only one tibble here
#> # A tibble: 3,880 × 14
#>    variable log2fc AveExpr      t   p_val  p_adj     b ref_group test_group
#>    <chr>     <dbl>   <dbl>  <dbl>   <dbl>  <dbl> <dbl> <chr>     <chr>     
#>  1 V1       -2.54     19.4 -2.28  0.0469  0.153  -4.23 H         C         
#>  2 V2        7.94     25.5  4.07  0.00251 0.0272 -1.38 H         C         
#>  3 V3       -0.834    29.0 -1.70  0.121   0.275  -5.10 H         C         
#>  4 V4       -0.665    31.4 -1.58  0.148   0.309  -5.27 H         C         
#>  5 V5       -1.62     25.0 -3.15  0.0110  0.0661 -2.84 H         C         
#>  6 V6        0.340    33.7  0.665 0.522   0.693  -6.23 H         C         
#>  7 V7        5.75     22.4  3.69  0.00462 0.0395 -1.98 H         C         
#>  8 V8       -0.733    30.5 -1.34  0.211   0.384  -5.57 H         C         
#>  9 V9       -1.68     25.6 -2.63  0.0263  0.111  -3.68 H         C         
#> 10 V10      -1.66     28.1 -4.10  0.00241 0.0266 -1.34 H         C         
#> # ℹ 3,870 more rows
#> # ℹ 5 more variables: protein <chr>, glycan_composition <comp>,
#> #   glycan_structure <struct>, protein_site <int>, gene <chr>
```

Excellent! Now let’s identify significantly differentially expressed
glycoforms between HCC and healthy samples, then see what biological
pathways they’re involved in.

``` r
clean_exp |>
  filter_sig_vars(limma_res, p_adj_cutoff = 0.05, fc_cutoff = 2) |>
  gly_enrich_go() |>
  autoplot()
#> 
#> 
```

![](case-study-1_files/figure-html/unnamed-chunk-13-1.png)

And that’s it—pathway enrichment in just a few lines! Here we filtered
the experiment to keep only significant variables and then performed
pathway enrichment. As this operation is so common, `glystats` provides
a dedicated function for it: `filter_sig_vars()`.

For the full statistical arsenal, check out [Get Started with
glystats](https://glycoverse.github.io/glystats/articles/glystats.html)
and [Get Started with
glyvis](https://glycoverse.github.io/glyvis/articles/glyvis.html).

## Advanced Motif Analysis

Up to now, we’ve covered standard glycoproteomics workflows. While
`glycoverse` certainly streamlines these analyses, it truly shines when
it comes to advanced glycan structure analysis.

Before diving into motifs, let’s get acquainted with
[`glyrepr::glycan_structure()`](https://glycoverse.github.io/glyrepr/reference/glycan_structure.html)
vectors.

``` r
clean_exp |>
  get_var_info() |>
  pull(glycan_structure)
#> <glycan_structure[3880]>
#> [1] NeuAc(??-?)Hex(??-?)HexNAc(??-?)Hex(??-?)[NeuAc(??-?)Hex(??-?)HexNAc(??-?)Hex(??-?)]Hex(??-?)HexNAc(??-?)HexNAc(??-
#> [2] NeuAc(??-?)Hex(??-?)HexNAc(??-?)[HexNAc(??-?)]Hex(??-?)[Hex(??-?)Hex(??-?)]Hex(??-?)HexNAc(??-?)HexNAc(??-
#> [3] Hex(??-?)HexNAc(??-?)Hex(??-?)[Hex(??-?)HexNAc(??-?)Hex(??-?)]Hex(??-?)HexNAc(??-?)HexNAc(??-
#> [4] NeuAc(??-?)Hex(??-?)HexNAc(??-?)Hex(??-?)[Hex(??-?)HexNAc(??-?)Hex(??-?)]Hex(??-?)HexNAc(??-?)HexNAc(??-
#> [5] Hex(??-?)HexNAc(??-?)Hex(??-?)HexNAc(??-?)Hex(??-?)[Hex(??-?)HexNAc(??-?)Hex(??-?)]Hex(??-?)HexNAc(??-?)HexNAc(??-
#> [6] NeuAc(??-?)Hex(??-?)HexNAc(??-?)Hex(??-?)[NeuAc(??-?)Hex(??-?)HexNAc(??-?)Hex(??-?)]Hex(??-?)HexNAc(??-?)HexNAc(??-
#> [7] Hex(??-?)HexNAc(??-?)Hex(??-?)[Hex(??-?)HexNAc(??-?)Hex(??-?)]Hex(??-?)HexNAc(??-?)HexNAc(??-
#> [8] dHex(??-?)Hex(??-?)HexNAc(??-?)Hex(??-?)[dHex(??-?)Hex(??-?)HexNAc(??-?)Hex(??-?)]Hex(??-?)HexNAc(??-?)HexNAc(??-
#> [9] Hex(??-?)HexNAc(??-?)Hex(??-?)[Hex(??-?)]Hex(??-?)HexNAc(??-?)HexNAc(??-
#> [10] NeuAc(??-?)Hex(??-?)HexNAc(??-?)Hex(??-?)[HexNAc(??-?)Hex(??-?)]Hex(??-?)HexNAc(??-?)HexNAc(??-
#> ... (3870 more not shown)
#> # Unique structures: 951
```

Just like [`integer()`](https://rdrr.io/r/base/integer.html) and
[`character()`](https://rdrr.io/r/base/character.html),
`glycan_structure()` is a specialized vector type. Some software (like
pGlyco3 and StrucGP) outputs structural information as text strings.
When you import this data using `glyread`, the `glyparse` package
automatically converts these strings into proper `glycan_structure()`
vectors and stores them in the variable information tibble. Note that
not all software provides structural data—some only give compositions.

Fortunately, our example dataset includes structural information,
opening up a world of advanced analytical possibilities. Let’s explore
motif analysis.

**Quick note:** The printed structures use IUPAC-condensed notation,
which we’ll also use for defining motifs below. Don’t worry if it looks
intimidating—we’ll include visual diagrams to help. That said, if you’re
planning to do serious structural analysis, learning IUPAC-condensed
notation is worth the investment. Check out [this
guide](https://glycoverse.github.io/glyrepr/articles/iupac.html) to get
started—it’s easier than it looks!

Lewis antigen epitopes are common structural motifs found on N-glycans.
Ignoring linkage specificity, we can define three main Lewis motif
families:

![](lewis_motifs.png)

Here’s how we express these motifs in IUPAC-condensed notation:

``` r
motifs <- c(
  lewis_by = "dHex(??-?)Hex(??-?)[dHex(??-?)]HexNAc(??-",
  lewis_ax = "Hex(??-?)[dHex(??-?)]HexNAc(??-",
  sia_lewis_ax = "NeuAc(??-?)Hex(??-?)[dHex(??-?)]HexNAc(??-"
)
```

A couple of important points:

1.  We’re using generic monosaccharide names (“Hex” vs. “Glc”) to match
    typical glycoproteomics data resolution
2.  The “??-?” represents unknown linkages—a common limitation in mass
    spectrometry data

This level of structural ambiguity is typical in glycoproteomics. The
key is matching your motif definitions to your data’s resolution.

Here’s our research question: **How many glycosites show differential
Lewis antigen expression across conditions?** Without `glycoverse`, this
would be a nightmare to tackle manually. Take a moment to imagine the
pain of doing this by hand!

Now, the `glycoverse` solution:

``` r
motif_anova_res <- clean_exp |>
  quantify_motifs(motifs) |>  # quantify these motifs
  gly_anova()  # and perform ANOVA
#> ℹ Number of groups: 4
#> ℹ Groups: "H", "M", "Y", and "C"
#> ℹ Pairwise comparisons will be performed, with levels coming first as reference groups.

get_tidy_result(motif_anova_res, "main_test")
#> # A tibble: 822 × 13
#>    variable term     df    sumsq   meansq statistic    p_val   p_adj post_hoc
#>    <chr>    <chr> <dbl>    <dbl>    <dbl>     <dbl>    <dbl>   <dbl> <chr>   
#>  1 V1       group     3 5.92e-31 1.97e-31     1.00    0.441    0.577 NA      
#>  2 V10      group     3 0        0          NaN     NaN      NaN     NA      
#>  3 V100     group     3 0        0          NaN     NaN      NaN     NA      
#>  4 V101     group     3 5.10e- 2 1.70e- 2     3.06    0.0916   0.231 NA      
#>  5 V102     group     3 7.81e- 3 2.60e- 3     3.75    0.0599   0.181 NA      
#>  6 V103     group     3 0        0          NaN     NaN      NaN     NA      
#>  7 V104     group     3 3.84e- 2 1.28e- 2     2.15    0.172    0.338 NA      
#>  8 V105     group     3 1.08e- 2 3.60e- 3     2.18    0.168    0.335 NA      
#>  9 V106     group     3 0        0          NaN     NaN      NaN     NA      
#> 10 V107     group     3 3.55e- 4 1.18e- 4     0.133   0.938    0.945 NA      
#> # ℹ 812 more rows
#> # ℹ 4 more variables: protein <chr>, protein_site <int>, motif <chr>,
#> #   gene <chr>
```

`quantify_motifs()` transforms your data into a new `experiment()`
object. Instead of quantifying individual glycans per glycosite, you now
have motif abundances per glycosite across samples. Since it’s still an
`experiment()` object, all `glystats` functions work
seamlessly—including `gly_anova()`.

Now we can answer our question using standard `tidyverse` operations,
since `motif_anova_res$tidy_result$main_test` is just a regular tibble:

``` r
motif_anova_res |>
  get_tidy_result("main_test") |>
  filter(p_adj < 0.05) |>
  group_by(motif) |>
  count()
#> # A tibble: 3 × 2
#> # Groups:   motif [3]
#>   motif            n
#>   <chr>        <int>
#> 1 lewis_ax        28
#> 2 lewis_by         9
#> 3 sia_lewis_ax    29
```

Want the specific glycosites with significant Lewis a/x epitopes? Easy:

``` r
motif_anova_res |>
  get_tidy_result("main_test") |>
  filter(p_adj < 0.05, motif == "lewis_ax") |>
  select(protein, protein_site)
#> # A tibble: 28 × 2
#>    protein protein_site
#>    <chr>          <int>
#>  1 P01011           271
#>  2 P01042           294
#>  3 P01877           205
#>  4 P01877            92
#>  5 P02675           394
#>  6 P02679            78
#>  7 P02749           162
#>  8 P02763            93
#>  9 P02790           240
#> 10 P03952           494
#> # ℹ 18 more rows
```

Here’s another common question: **Which pathways are enriched in
proteins that carry Lewis a/x epitopes?**

For this analysis, we don’t need motif quantification—we just need to
know which proteins have these motifs.
[`glymotif::add_motifs_lgl()`](https://glycoverse.github.io/glymotif/reference/add_motifs_int.html)
is perfect for this.

``` r
kegg_res <- clean_exp |>
  add_motifs_lgl(motifs) |>
  filter_var(lewis_ax) |>
  gly_enrich_kegg()

autoplot(kegg_res)
```

![](case-study-1_files/figure-html/unnamed-chunk-19-1.png)

`add_motifs_lgl()` adds three new TRUE/FALSE columns (`lewis_by`,
`lewis_ax`, `sia_lewis_ax`) to the variable information. `filter_var()`
keeps only glycoforms with Lewis a/x epitopes. Finally,
`gly_enrich_kegg()` runs pathway enrichment on the remaining proteins.

`glymotif` has much more to offer beyond these examples. Dive deeper
with [Get Started with
glymotif](https://glycoverse.github.io/glymotif/articles/glymotif.html).

## Derived Trait Analysis

Let’s wrap up with derived traits—a clever analytical approach developed
by the N-glycomics community for glycome characterization. Classic
examples include:

- High-mannose glycan proportion
- Core-fucosylation rate within complex glycans
- Average sialylation per galactose residue

`glydet` adapts this concept for glycoproteomics by treating each
glycosite as its own mini-glycome. This enables site-specific trait
calculation and much richer biological insights.

Using `glydet` couldn’t be simpler:

``` r
trait_exp <- derive_traits(clean_exp)  # from `glydet`
trait_exp
#> 
#> ── Traitproteomics Experiment ──────────────────────────────────────────────────
#> ℹ Expression matrix: 12 samples, 3836 variables
#> ℹ Sample information fields: group <fct>
#> ℹ Variable information fields: protein <chr>, protein_site <int>, trait <chr>, gene <chr>
```

That’s it! Just like `quantify_motifs()`, `derive_traits()` creates a
new `experiment()` object, but now with trait values per glycosite per
sample.

The variable information shows what we’re working with:

``` r
get_var_info(trait_exp)
#> # A tibble: 3,836 × 5
#>    variable protein protein_site trait gene 
#>    <chr>    <chr>          <int> <chr> <chr>
#>  1 V1       A6NJW9            49 TM    CD8B2
#>  2 V2       A6NJW9            49 TH    CD8B2
#>  3 V3       A6NJW9            49 TC    CD8B2
#>  4 V4       A6NJW9            49 MM    CD8B2
#>  5 V5       A6NJW9            49 CA2   CD8B2
#>  6 V6       A6NJW9            49 CA3   CD8B2
#>  7 V7       A6NJW9            49 CA4   CD8B2
#>  8 V8       A6NJW9            49 TF    CD8B2
#>  9 V9       A6NJW9            49 TFc   CD8B2
#> 10 V10      A6NJW9            49 TFa   CD8B2
#> # ℹ 3,826 more rows
```

The “trait” column lists all the derived traits we can analyze.

`glydet` comes with a comprehensive set of built-in traits:

- **`TM`**: Proportion of high-mannose glycans
- **`TH`**: Proportion of hybrid glycans  
- **`TC`**: Proportion of complex glycans
- **`MM`**: Average number of mannoses within high-mannose glycans
- **`CA2`**: Proportion of bi-antennary glycans within complex glycans
- **`CA3`**: Proportion of tri-antennary glycans within complex glycans
- **`CA4`**: Proportion of tetra-antennary glycans within complex
  glycans
- **`TF`**: Proportion of fucosylated glycans
- **`TFc`**: Proportion of core-fucosylated glycans
- **`TFa`**: Proportion of arm-fucosylated glycans
- **`TB`**: Proportion of glycans with bisecting GlcNAc
- **`SG`**: Average degree of sialylation per galactose
- **`GA`**: Average degree of galactosylation per antenna
- **`TS`**: Proportion of sialylated glycans

These represent the most widely used traits in glycomics literature.

Let’s identify glycosites with significantly different core-fucosylation
levels (TFc) across conditions:

``` r
trait_exp |>
  filter_var(trait == "TFc") |>  # from `glyexp`
  gly_anova() |>
  get_tidy_result("main_test") |>
  filter(p_adj < 0.05)
#> ℹ Number of groups: 4
#> ℹ Groups: "H", "M", "Y", and "C"
#> ℹ Pairwise comparisons will be performed, with levels coming first as reference groups.
#> # A tibble: 20 × 13
#>    variable term     df     sumsq    meansq statistic     p_val   p_adj post_hoc
#>    <chr>    <chr> <dbl>     <dbl>     <dbl>     <dbl>     <dbl>   <dbl> <chr>   
#>  1 V1115    group     3 0.0000941 0.0000314     26.2    1.72e-4 3.46e-3 H_vs_M;…
#>  2 V1227    group     3 0.0629    0.0210        14.0    1.50e-3 1.76e-2 H_vs_Y;…
#>  3 V1353    group     3 0.00231   0.000770      19.3    5.05e-4 7.91e-3 H_vs_C;…
#>  4 V1381    group     3 0.00640   0.00213       14.9    1.23e-3 1.74e-2 H_vs_Y;…
#>  5 V1661    group     3 0.0299    0.00998       14.3    1.40e-3 1.76e-2 H_vs_M;…
#>  6 V1675    group     3 0.0174    0.00581       43.1    2.78e-5 9.80e-4 H_vs_M;…
#>  7 V1927    group     3 0.0549    0.0183         9.97   4.44e-3 4.34e-2 H_vs_Y;…
#>  8 V2165    group     3 0.0174    0.00581      172.     1.34e-7 1.89e-5 H_vs_M;…
#>  9 V2179    group     3 0.0000417 0.0000139      8.71   6.70e-3 4.93e-2 H_vs_Y;…
#> 10 V247     group     3 0.0221    0.00735        9.20   5.68e-3 4.57e-2 H_vs_Y;…
#> 11 V2487    group     3 0.0644    0.0215        74.1    3.53e-6 2.49e-4 H_vs_M;…
#> 12 V2655    group     3 0.0305    0.0102         9.12   5.84e-3 4.57e-2 H_vs_Y;…
#> 13 V2669    group     3 0.000519  0.000173       9.14   5.79e-3 4.57e-2 H_vs_C;…
#> 14 V2837    group     3 0.00547   0.00182       27.5    1.45e-4 3.40e-3 H_vs_M;…
#> 15 V401     group     3 0.0854    0.0285         8.58   6.99e-3 4.93e-2 H_vs_M;…
#> 16 V415     group     3 0.000765  0.000255       9.85   4.61e-3 4.34e-2 H_vs_M;…
#> 17 V457     group     3 0.000548  0.000183      52.2    1.34e-5 6.32e-4 H_vs_C;…
#> 18 V709     group     3 0.0771    0.0257        22.4    3.00e-4 5.29e-3 H_vs_M;…
#> 19 V863     group     3 0.00204   0.000680      10.3    4.00e-3 4.34e-2 H_vs_Y;…
#> 20 V919     group     3 0.00365   0.00122       31.9    8.46e-5 2.39e-3 H_vs_C;…
#> # ℹ 4 more variables: protein <chr>, protein_site <int>, trait <chr>,
#> #   gene <chr>
```

Once again, it’s just that straightforward.

This just scratches the surface of `glydet`’s capabilities. The real
power lies in defining custom traits tailored to your research
questions. Explore the possibilities in [Get Started with
glydet](https://glycoverse.github.io/glydet/articles/glydet.html).

## What’s Next?

This vignette has given you a taste of `glycoverse` in action through a
real-world glycoproteomics workflow. But we’ve barely scratched the
surface! Now that you’ve got the basics down, you’re ready to unlock the
full potential of each package.

Here’s your roadmap to mastering each component:

- **[glyexp](https://glycoverse.github.io/glyexp/articles/glyexp.html)**
  — Master experiment objects and data manipulation
- **[glyread](https://glycoverse.github.io/glyread/articles/glyread.html)**
  — Import and organize glycoproteomics data
- **[glyclean](https://glycoverse.github.io/glyclean/articles/glyclean.html)**
  — Build custom preprocessing pipelines  
- **[glystats](https://glycoverse.github.io/glystats/articles/glystats.html)**
  — Explore the full statistical toolkit
- **[glyvis](https://glycoverse.github.io/glyvis/articles/glyvis.html)**
  — Create stunning visualizations
- **[glymotif](https://glycoverse.github.io/glymotif/articles/glymotif.html)**
  — Define and analyze custom motifs
- **[glydet](https://glycoverse.github.io/glydet/articles/glydet.html)**
  — Create powerful derived traits
- **[glyenzy](https://glycoverse.github.io/glyenzy/articles/glyenzy.html)**
  — Explore enzyme-substrate relationships (we didn’t cover this one,
  but it’s fascinating!)
- **[glyrepr](https://glycoverse.github.io/glyrepr/articles/glyrepr.html)**
  — Master glycan structure representation
- **[glyparse](https://glycoverse.github.io/glyparse/articles/glyparse.html)**
  — Parse and convert structural formats

Happy glycan hunting! 🧬
