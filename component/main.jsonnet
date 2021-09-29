// main template for keycloak-attribute-sync-controller
local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
local inv = kap.inventory();
// The hiera parameters for the component
local params = inv.parameters.keycloak_attribute_sync_controller;

// Define outputs below
{
}
