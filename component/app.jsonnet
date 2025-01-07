local kap = import 'lib/kapitan.libjsonnet';
local inv = kap.inventory();
local params = inv.parameters.keycloak_attribute_sync_controller;
local argocd = import 'lib/argocd.libjsonnet';

local app = argocd.App('keycloak-attribute-sync-controller', params.namespace);

local appPath =
  local project = std.get(app, 'spec', { project: 'syn' }).project;
  if project == 'syn' then 'apps' else 'apps-%s' % project;

{
  ['%s/keycloak-attribute-sync-controller' % appPath]: app,
}
