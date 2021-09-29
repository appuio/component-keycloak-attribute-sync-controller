local kap = import 'lib/kapitan.libjsonnet';
local inv = kap.inventory();
local params = inv.parameters.keycloak_attribute_sync_controller;
local argocd = import 'lib/argocd.libjsonnet';

local app = argocd.App('keycloak-attribute-sync-controller', params.namespace);

{
  'keycloak-attribute-sync-controller': app,
}
