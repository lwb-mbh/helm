# Application Helm Chart

Umbrella-Chart für Applikationen. Das Chart stellt als Basis 

* Basis-URL: zum Aufruf des Projekts im Browser, Charts können die Basis-URL erweitern z.B. phpMyAdmin pma + BasisURL
* Environment: wird für verschiedene Unterscheidungen herangezogen z.B. Ziels von Backups
* Zentrale Bereitstellung von [ImagePullSecrets](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/)
* Aktivierung der Sub-Charts

## Hinweis

* Aufgrund der Ableitung der URL's können die Sub-Charts Drupal, Drupal7, Node und Tomcat nicht gleichzeitig aktiviert werden, da die URL's kollidieren würden.
