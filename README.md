# VariableTypes.jl

Detects basic statistical variable types of data:

* **Quantitative** - Measurable variables.
  * **Continuous** - Can take on any value in a continuum.
  * **Discrete** - Can take on only specific values in a continuum.
* **Categorical** - Properties of variables.

# Methodology

The available types in this package are those that do not inherently require domain knowledge or opinion of the dataset. For this reason `Categorical` has not been further subdivided into *Nominal* or *Ordinal*. For instance, a variable containing values *A, B, C, D* could be considered either *Nominal* if the letters denote a group or *Ordinal* if they are academic grades.

Instead, this package relies on Julia's type system to determine statistical types. Simply put, quantitative variables inherit from `Number` while categorical variables are presumed to inherit from non-number types.

Ambiguities related to numbers being treated categorically (e.g. discrete integers representing groups) can therefore be avoided by converting the values into more indicative types such as strings or symbols.

# Useage

#### Single Values

```julia
# Single values
vartype(1)
> Discrete

# Rationals are classified as Discrete since they are composed of Integers
vartype(11//16)
> Discrete

vartype(2.5)
> Continuous

vartype(1//2) <: Quantitative
> true

vartype(true)
> Categorical

vartype("Group A")
> Categorical

vartype(:northeast)
> Categorical
```

#### Vectors

```julia
vartype(v, searchlen=100)
```
`searchlen` will determine the maximum number of items to examine before resolving to a `VariableType`.


```julia
# Vectors
vartype(rand(10))
> Discrete

vartype([1.5, 2.3, 4.0, :abcd])
> Categorical

vartype([1.5, 2.3, 4.0, :abcd], 3)
> Continuous
```

#### Matrices

```julia
vartype(v, dim=1, searchlen=100)
```

`dim` determines whether to move across rows (2) or columns (1). Again, `searchlen` sets the maximum number of items to examine in each row or column.

```julia
A = [1 2.5 "A"
     2 3.5 "B"
     3 4.5 "C"]

vartype(A)
> [Discrete, Continuous, Categorical]

# Resolves to a Categorical because each row contains a string
vartype(A, 2)
> [Categorical, Categorical, Categorical]

# Resolves to Continuous since the string is outside of `searchlen`
# and each row contains a Float
vartype(A, 2, 2)
> [Continuous, Continuous, Continuous]

```
