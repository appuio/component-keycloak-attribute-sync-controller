local kube = import 'lib/kube.libjsonnet';

/**
  * \brief Helper to create AttributeSync objects.
  *
  * \arg The name of the AttributeSync.
  * \return An AttributeSync object.
  */
local AttributeSync(name) = kube._Object('keycloak.appuio.io/v1alpha1', 'AttributeSync', name) {};

{
  AttributeSync: AttributeSync,
}
