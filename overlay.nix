final: prev:
let
  ckb-next = final.callPackage ./pkgs/ckb-next { };
  quazip = final.callPackage ./pkgs/quazip { };
in
{
  inherit quazip ckb-next;
  ckb-next-experimental =
    let
      # From https://github.com/ckb-next/ckb-next/pull/997, which
      # tries to add support for Scimitar Elite Wireless, but
      # apparently then does not work with other Scimitar mice.
      #
      # This version does not work for my Scimitar Elite Wireless,
      # though.
      rev = "677749020edb3272d379c103c956b6933a59fbb5";
      hash = "sha256-tyGxXPw/73GsRLSWAca1fwJc3X/61DCWUqm5l048Wqk=";
    in
    ckb-next.overrideAttrs (
      _finalAttrs: prevAttrs: {
        version = rev;
        src = prevAttrs.src // {
          inherit rev hash;
        };
      }
    );
}
