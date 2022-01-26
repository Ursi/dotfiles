let
  systems = {
    hp-envy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOjLWvLvgY4VSV3rvihTjjLRtgHQIA50U43ALdl66IzO root@hp-envy";
  };
  users = {
    matthew-t480 = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQClm+SMN9Bg1HZ+MjH1VQYEXAnslGWT9564pj/KGO79WMQLUxdp3WWa1hQadf2PleAIEFEul3knrpRSEK3yHcCk3g+sCh3XIJcFZLesswe0V+kCAw+JBSd18ESJ4Qko+iDK95cDzucLFwXB10FMVKQCrX90KR+Fp6s6eJHcZGmpxTPgNulDpAjM2APluM3xBCe6zZzt+iNIzn3J8PRKbpNNbuw/LMRU8+udrGbLavUMcSk7ER9pAyLGhz//9aHWDPu7ZRje+vTWgnGFpzbtEzdjnP+2v45nLKWG7o7WdTAsAR8WSccjtNoBiVgSmpHr07zJ0/gTeL4PUkk3lbtzF/PdtTQGm3Ng4SjOBlhRVaTuKBlF2X/Rwq+W4LCbHVgA79MyhJxL2TDbKBPUSLfckqxP89e8Q7iQ4XjIHqVb50ojNNLGcOQRrHq14Twwx/ZDDQvMXCsLwM6vyoYa8KdSaASEr1clx78qNp9PHGlr+UztW+EsoZI7j1tzcHMmq2BSK90= matthew@t480";
    ursi-hp-envy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICiC9a/2NVbF8Viqvq3kPdzIkQwAJUbK8btC54ovtMJa masondeanm@aol.com";
  };
in
{
  "ardana-cachix-auth.age".publicKeys = [ users.ursi-hp-envy users.matthew-t480 systems.hp-envy ];
}
