# potential libolm vulnerability affecting Matrix clients gets cinny marked as insecure

final: prev:
  let
    inherit (final.lib) removeAttrs;
    makeNotInsecure = drv: drv.overrideAttrs (_: prevAttrs: {
      meta = removeAttrs prevAttrs.meta ["knownVulnerabilities"];
    });
  in {
    cinny = makeNotInsecure prev.cinny;
    cinny-desktop = makeNotInsecure prev.cinny-desktop;
    cinny-unwrapped = makeNotInsecure prev.cinny-unwrapped;
  }
