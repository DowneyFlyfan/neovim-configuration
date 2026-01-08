local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local fmt = extras.fmt
local m = extras.m
local l = extras.l
local postfix = require("luasnip.extras.postfix").postfix

ls.add_snippets("matlab", {
	ls.snippet("cm", {
		t({ "%{", "" }),
		i(1, "comment"),
		t({ "", "%}" }),
	}),
})

ls.add_snippets("sh", {
	ls.snippet("cm", {
		t("# ==== "),
		i(1, "comment"),
		t(" ===="),
	}),
})

ls.add_snippets("c", {
	ls.snippet("cm", {
		t("// ----"),
		i(1, "comment"),
		t(" ----"),
	}),
})

ls.add_snippets("python", {
	ls.snippet("def", {
		t("def "),
		i(1, "function_name"),
		t("("),
		i(2, "args"),
		t("):"),
		t("\n    "),
		i(3, "pass"),
	}),
	ls.snippet("cm", {
		t("# ---- "),
		i(1, "comment"),
		t(" ----"),
	}),
	ls.snippet("ep", {
		t({ 'r"""', "" }),
		i(1, "Explanation"),
		t({ "", '"""' }),
	}),
})

-- Markdown Snippets
ls.add_snippets("markdown", {
	-- Brackets & Matrixs & Integral
	ls.snippet("eq", {
		t({ "$$", "\\begin{equation}", "\\begin{aligned}", "" }),
		i(1, ""),
		t({ "", "\\end{aligned}", "\\end{equation}", "$$" }),
	}),

	ls.snippet("cs", {
		t({ "\\begin{cases}", "" }),
		i(1, ""),
		t({ "", "\\end{cases}" }),
	}),

	ls.snippet("it", {
		t("\\int_{"),
		i(1, ""),
		t("}^{"),
		i(2, "} "),
	}),

	ls.snippet("iit", {
		t("\\iint_{"),
		i(1, ""),
		t("}^{"),
		i(2, "} "),
	}),

	ls.snippet("pt", {
		t("\\frac{\\partial "),
		i(1, ""),
		t("}{\\partial "),
		i(2, "} "),
	}),

	ls.snippet("f", {
		t("\\frac{"),
		i(1, ""),
		t("}{"),
		i(2, "} "),
	}),

	ls.snippet("df", {
		t("\\dfrac{"),
		i(1, ""),
		t("}{"),
		i(2, "} "),
	}),

	ls.snippet("ax", {
		t("\\approx "),
	}),

	ls.snippet("bm", {
		t({ "\\begin{bmatrix}", "" }),
		i(1, ""),
		t({ "", "\\end{bmatrix}" }),
	}),

	ls.snippet("bgb", {
		t("\\big[ "),
		i(1, ""),
		t(" \\big]"),
	}),

	ls.snippet("Bgb", {
		t("\\Big[ "),
		i(1, ""),
		t(" \\Big]"),
	}),

	ls.snippet("bgp", {
		t("\\big\\{ "),
		i(1, ""),
		t(" \\big\\}"),
	}),

	ls.snippet("Bgp", {
		t("\\Big\\{ "),
		i(1, ""),
		t(" \\Big\\}"),
	}),

	-- Decorations
	ls.snippet("us", {
		t("\\underset{"),
		i(1, ""),
		t("}{"),
		i(2, "} "),
	}),

	ls.snippet("os", {
		t("\\overset{"),
		i(1, ""),
		t("}{"),
		i(2, "} "),
	}),

	ls.snippet("td", {
		t("\\tilde{"),
		i(1, ""),
		t("} "),
	}),

	ls.snippet("wtd", {
		t("\\widetilde{"),
		i(1, ""),
		t("} "),
	}),

	ls.snippet("ht", {
		t("\\hat{"),
		i(1, ""),
		t("} "),
	}),

	ls.snippet("cc", {
		t("\\circ"),
		i(1, ""),
	}),

	ls.snippet("wht", {
		t("\\widehat{"),
		i(1, ""),
		t("} "),
	}),

	-- Font Family
	ls.snippet("mc", {
		t("\\mathcal{"),
		i(1, ""),
		t("} "),
	}),

	ls.snippet("mbb", {
		t("\\mathbb{"),
		i(1, ""),
		t("} "),
	}),

	ls.snippet("mbf", {
		t("\\mathbf{"),
		i(1, ""),
		t("} "),
	}),

	ls.snippet("mit", {
		t("\\mathit{"),
		i(1, ""),
		t("} "),
	}),

	ls.snippet("mfk", {
		t("\\mathfrak{"),
		i(1, ""),
		t("} "),
	}),

	ls.snippet("mrm", {
		t("\\mathrm{"),
		i(1, ""),
		t("} "),
	}),

	ls.snippet("tx", {
		t("\\text{"),
		i(1, ""),
		t("} "),
	}),

	-- Greece Alphabet
	ls.snippet("sg", {
		t("\\sigma "),
	}),

	ls.snippet("te", {
		t("\\triangleq "),
	}),

	ls.snippet("Om", {
		t("\\Omega "),
	}),

	ls.snippet("om", {
		t("\\omega "),
	}),

	ls.snippet("tt", {
		t("\\theta "),
	}),

	ls.snippet("Tt", {
		t("\\Theta "),
	}),

	ls.snippet("vrp", {
		t("\\varepsilon "),
	}),

	ls.snippet("ep", {
		t("\\epsilon "),
	}),

	ls.snippet("dt", {
		t("\\delta "),
	}),

	ls.snippet("Dt", {
		t("\\Delta "),
	}),

	ls.snippet("gm", {
		t("\\gamma "),
	}),

	ls.snippet("Gm", {
		t("\\Gamma "),
	}),

	ls.snippet("ap", {
		t("\\alpha "),
	}),

	ls.snippet("bt", {
		t("\\beta "),
	}),

	ls.snippet("kp", {
		t("\\kappa "),
	}),

	ls.snippet("nl", {
		t("\\nabla "),
	}),

	ls.snippet("lbd", {
		t("\\lambda "),
	}),

	-- Mathmatical Symbols
	ls.snippet("sm", {
		t("\\sum_{"),
		i(1, ""),
		t("}^{"),
		i(2, "} "),
	}),

	ls.snippet("sr", {
		t("\\sqrt{"),
		i(1, ""),
		t("}"),
	}),

	ls.snippet("pd", {
		t("\\prod_{"),
		i(1, ""),
		t("}^{"),
		i(2, "} "),
	}),

	ls.snippet("cd", {
		t("\\cdot "),
	}),

	ls.snippet("vd", {
		t("\\vdots "),
	}),

	ls.snippet("ts", {
		t("\\times "),
	}),

	ls.snippet("ot", {
		t("\\otimes "),
	}),

	ls.snippet("op", {
		t("\\oplus"),
	}),

	ls.snippet("tf", {
		t("\\therefore "),
	}),

	ls.snippet("if", {
		t("\\infty "),
	}),

	ls.snippet("id", {
		t("\\perp \\! \\! \\! \\perp "),
	}),

	-- Arrows, Comparator
	ls.snippet("ra", {
		t("\\xrightarrow{"),
		i(1, ""),
		t("} "),
	}),
	ls.snippet("Ra", {
		t("\\xRightarrow{"),
		i(1, ""),
		t("} "),
	}),

	ls.snippet("la", {
		t("\\xleftarrow{"),
		i(1, ""),
		t("} "),
	}),
	ls.snippet("La", {
		t("\\xLeftarrow{"),
		i(1, ""),
		t("} "),
	}),

	ls.snippet("ar", {
		t("\\xleftrightarrow{"),
		i(1, ""),
		t("} "),
	}),
	ls.snippet("Ar", {
		t("\\xLeftrightarrow{"),
		i(1, ""),
		t("} "),
	}),

	ls.snippet("da", {
		t("\\downarrow "),
	}),

	ls.snippet("upa", {
		t("\\uparrow "),
	}),

	ls.snippet("ls", {
		t("\\lesssim "),
	}),

	ls.snippet("gs", {
		t("\\gtrsim"),
	}),

	ls.snippet("vc", {
		t("\\vec{\\pmb{"),
		i(1, ""),
		t("}} "),
	}),

	-- Others
	ls.snippet("im", {
		t("![](./imgs/"),
		i(1, ""),
		t(")"),
	}),
})

-- JSX Snippets
ls.add_snippets("javascriptreact", {
	ls.snippet("cm", {
		t("{/* "),
		i(1, "comment"),
		t(" */}"),
	}),
})
