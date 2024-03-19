### A Pluto.jl notebook ###
# v0.19.40

using Markdown
using InteractiveUtils

# ╔═╡ 97d9caaf-6185-4ffc-a9ab-06a87b557ef7
using MPI

# ╔═╡ 76ff3e03-0d45-4f61-bea6-f0162435e592
using T8code

# ╔═╡ 27457e2e-e5ed-11ee-37d7-a590fe9aece0
using PlutoVista

# ╔═╡ 16c9af9d-b538-472c-8676-5385dacfaae5
md"""
# Introduction to Adaptive Meshes with [T8code.jl](https://github.com/DLR-AMR/T8code.jl)

This [Pluto.jl](https://github.com/fonsp/Pluto.jl)
notebook contains the source code for the hands-on introduction to
adaptive meshes with [T8code.jl](https://github.com/DLR-AMR/T8code.jl)
given by Hendrik Ranocha at the 
[M3ODEL Lunch Talk Seminar](https://model.uni-mainz.de/lunch-talks/) 
on March 28, 2024.
You can find the source code in the 
[accompanying repository](https://github.com/ranocha/2024-talk-m3odel).
"""

# ╔═╡ c488fcdf-a69d-4a76-b470-87dceb32a600
md"""
#### Installing and loading packages

_When running this notebook for the first time, this could take up several minutes. Hang in there!_
"""

# ╔═╡ b8b554f7-4cc9-4845-a3d4-e393ccfab2d1
md"""
## Initializing packages
"""

# ╔═╡ 08fe9b18-92e5-40e9-87af-826bcab96d4f
begin
	if 
	MPI.Init()
	const comm = MPI.COMM_WORLD

	# It is important to set `catch_signals` to 0 when running
	# Julia with multiple threads. Otherwise, we get segfaults
	# since Julia uses signals to control the GC.
	let catch_signals = 0, print_backtrace = 1, log_handler = C_NULL
		T8code.Libt8.sc_init(comm, catch_signals, print_backtrace, log_handler, 
							 T8code.Libt8.SC_LP_ESSENTIAL)
	end
	t8_init(T8code.Libt8.SC_LP_PRODUCTION)
end

# ╔═╡ d51d9c33-c181-40e0-a745-b980ad445407
cmesh = let
	# Coordinates of the enclosing rectangle
	x = (0.0, 10.0)
	y = (0.0, 10.0)

    # Vertices of the triangles
    vertices = [
        x[1], y[1], 0, # tree 0, triangle
        x[2], y[1], 0,
        x[2], y[2], 0,
        x[1], y[1], 0, # tree 1, triangle
        x[2], y[2], 0,
        x[1], y[2], 0,
    ]

    # Initialize the coarse mesh
    cmesh_ref = Ref(t8_cmesh_t())
    t8_cmesh_init(cmesh_ref)
    cmesh = cmesh_ref[]

    # Define the (linear) geometry
    linear_geom = t8_geometry_linear_new(2)
    t8_cmesh_register_geometry(cmesh, linear_geom)

    # Define of the classes of the trees
    t8_cmesh_set_tree_class(cmesh, 0, T8_ECLASS_TRIANGLE)
    t8_cmesh_set_tree_class(cmesh, 1, T8_ECLASS_TRIANGLE)

    # Set the vertices for each tree
    t8_cmesh_set_tree_vertices(cmesh, 0, pointer(vertices, 0), 3)
    t8_cmesh_set_tree_vertices(cmesh, 1, pointer(vertices, 9), 3)

    # Define the face neighbors between the different trees
    t8_cmesh_set_join(cmesh, 0, 1, 1, 2, 0)

    # Commit the mesh
    t8_cmesh_commit(cmesh, comm)

	cmesh
end

# ╔═╡ d0ca6936-4c60-4f6b-a893-9bc3195b1ccc


# ╔═╡ 3b7300d3-9c15-4ab9-ac17-11ca78c6fae2
md"## Appendix"

# ╔═╡ 8eb47952-972c-4e08-9d24-0baa359f7d75
space = html"<br><br><br>";

# ╔═╡ 157f6fba-a318-4003-ad0d-0286f09bd310
space

# ╔═╡ ce9fcf0f-46d2-4b54-b042-b36d041c7d3a
space

# ╔═╡ 18af59be-b522-4400-be24-547999dbb756
space

# ╔═╡ c032c9d9-f8eb-4a23-93fc-6b3adcec6a92
big_space = html"<br><br><br><br><br><br><br><br><br>";

# ╔═╡ 10d7b730-4444-4927-889a-440e7102bf90
big_space

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
MPI = "da04e1cc-30fd-572f-bb4f-1f8673147195"
PlutoVista = "646e1f28-b900-46d7-9d87-d554eb38a413"
T8code = "d0cc0030-9a40-4274-8435-baadcfd54fa1"

[compat]
MPI = "~0.20.19"
PlutoVista = "~1.0.1"
T8code = "~0.5.3"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.2"
manifest_format = "2.0"
project_hash = "682453a8a3b15b85f754021b0c9f6e7bd64a5896"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "0f748c81756f2e5e6854298f11ad8b2dfae6911a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.CEnum]]
git-tree-sha1 = "389ad5c84de1ae7cf0e28e381131c98ea87d54fc"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.5.0"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "PrecompileTools", "Random"]
git-tree-sha1 = "67c1f244b991cad9b0aa4b7540fb758c2488b129"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.24.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "Requires", "Statistics", "TensorCore"]
git-tree-sha1 = "a1f44953f2382ebb937d60dafbe2deea4bd23249"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.10.0"

    [deps.ColorVectorSpace.extensions]
    SpecialFunctionsExt = "SpecialFunctions"

    [deps.ColorVectorSpace.weakdeps]
    SpecialFunctions = "276daf66-3868-5448-9aa4-cd146d93841b"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.0+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.GridVisualizeTools]]
deps = ["ColorSchemes", "Colors", "DocStringExtensions", "StaticArraysCore"]
git-tree-sha1 = "e111f256aa000c4e4662d1119281b751aa66dc37"
uuid = "5573ae12-3b76-41d9-b48c-81d0b6e61cc5"
version = "1.1.0"

[[deps.Hwloc_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl"]
git-tree-sha1 = "ca0f6bf568b4bfc807e7537f081c81e35ceca114"
uuid = "e33a78d0-f292-5ffc-b300-72abe9b543c8"
version = "2.10.0+0"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JLLWrappers]]
deps = ["Artifacts", "Preferences"]
git-tree-sha1 = "7e5d6779a1e09a36db2a7b6cff50942a0a7d0fca"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.5.0"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.6.4+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MPI]]
deps = ["Distributed", "DocStringExtensions", "Libdl", "MPICH_jll", "MPIPreferences", "MPItrampoline_jll", "MicrosoftMPI_jll", "OpenMPI_jll", "PkgVersion", "PrecompileTools", "Requires", "Serialization", "Sockets"]
git-tree-sha1 = "4e3136db3735924f96632a5b40a5979f1f53fa07"
uuid = "da04e1cc-30fd-572f-bb4f-1f8673147195"
version = "0.20.19"

    [deps.MPI.extensions]
    AMDGPUExt = "AMDGPU"
    CUDAExt = "CUDA"

    [deps.MPI.weakdeps]
    AMDGPU = "21141c5a-9bdb-4563-92ae-f87d6854732e"
    CUDA = "052768ef-5323-5732-b1bb-66c8b64840ba"

[[deps.MPICH_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Hwloc_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "MPIPreferences", "TOML"]
git-tree-sha1 = "656036b9ed6f942d35e536e249600bc31d0f9df8"
uuid = "7cb0a576-ebde-5e09-9194-50597f1243b4"
version = "4.2.0+0"

[[deps.MPIPreferences]]
deps = ["Libdl", "Preferences"]
git-tree-sha1 = "8f6af051b9e8ec597fa09d8885ed79fd582f33c9"
uuid = "3da0fdf6-3ccc-4f1b-acd9-58baa6c99267"
version = "0.1.10"

[[deps.MPItrampoline_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Hwloc_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "MPIPreferences", "TOML"]
git-tree-sha1 = "77c3bd69fdb024d75af38713e883d0f249ce19c2"
uuid = "f1f71cc9-e9ae-5b93-9b94-4fe0e1ad3748"
version = "5.3.2+0"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.MicrosoftMPI_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f12a29c4400ba812841c6ace3f4efbb6dbb3ba01"
uuid = "9237b28f-5490-5468-be7b-bb81f5f5e6cf"
version = "10.1.4+2"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+4"

[[deps.OpenMPI_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "MPIPreferences", "TOML"]
git-tree-sha1 = "e25c1778a98e34219a00455d6e4384e017ea9762"
uuid = "fe0851c0-eecd-5654-98d4-656369965a5c"
version = "4.1.6+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "f9501cc0430a26bc3d156ae1b5b0c1b47af4d6da"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.3.3"

[[deps.PlutoVista]]
deps = ["AbstractPlutoDingetjes", "ColorSchemes", "Colors", "DocStringExtensions", "GridVisualizeTools", "HypertextLiteral", "UUIDs"]
git-tree-sha1 = "5be7548065d668761814809e2c7ee33310a3d82f"
uuid = "646e1f28-b900-46d7-9d87-d554eb38a413"
version = "1.0.1"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

[[deps.T8code]]
deps = ["CEnum", "Libdl", "MPI", "MPIPreferences", "Preferences", "Reexport", "TOML", "UUIDs", "t8code_jll"]
git-tree-sha1 = "7e5ea1ac7b765c82845fe9855f779cbbb731f18b"
uuid = "d0cc0030-9a40-4274-8435-baadcfd54fa1"
version = "0.5.3"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Tricks]]
git-tree-sha1 = "eae1bb484cd63b36999ee58be2de6c178105112f"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.8"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"

[[deps.t8code_jll]]
deps = ["Artifacts", "JLLWrappers", "LazyArtifacts", "Libdl", "MPICH_jll", "MPIPreferences", "MPItrampoline_jll", "MicrosoftMPI_jll", "OpenMPI_jll", "TOML", "Zlib_jll"]
git-tree-sha1 = "7e0eb2fd3c551e70388de30d04b29667bd61f9b2"
uuid = "4ee9bed8-4011-53f7-90c2-22363c2f500d"
version = "1.6.1+1"
"""

# ╔═╡ Cell order:
# ╟─16c9af9d-b538-472c-8676-5385dacfaae5
# ╟─157f6fba-a318-4003-ad0d-0286f09bd310
# ╟─c488fcdf-a69d-4a76-b470-87dceb32a600
# ╠═97d9caaf-6185-4ffc-a9ab-06a87b557ef7
# ╠═76ff3e03-0d45-4f61-bea6-f0162435e592
# ╠═27457e2e-e5ed-11ee-37d7-a590fe9aece0
# ╟─ce9fcf0f-46d2-4b54-b042-b36d041c7d3a
# ╟─b8b554f7-4cc9-4845-a3d4-e393ccfab2d1
# ╠═08fe9b18-92e5-40e9-87af-826bcab96d4f
# ╠═d51d9c33-c181-40e0-a745-b980ad445407
# ╠═d0ca6936-4c60-4f6b-a893-9bc3195b1ccc
# ╟─18af59be-b522-4400-be24-547999dbb756
# ╟─10d7b730-4444-4927-889a-440e7102bf90
# ╟─3b7300d3-9c15-4ab9-ac17-11ca78c6fae2
# ╠═8eb47952-972c-4e08-9d24-0baa359f7d75
# ╠═c032c9d9-f8eb-4a23-93fc-6b3adcec6a92
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
