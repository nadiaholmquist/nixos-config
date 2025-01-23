final: prev: {
  cemu = prev.cemu.overrideAttrs (_: prevAttrs: {
    patches = prevAttrs.patches ++ [
      (final.fetchpatch {
        url = "https://github.com/cemu-project/Cemu/commit/2b0cbf7f6b6c34c748585d255ee7756ff592a502.patch";
        hash = "sha256-jHB/9MWZ/oNfUgZtxtgkSN/OnRARSuGVfXFFB9ldDpI=";
      })
    ];
  });
}
