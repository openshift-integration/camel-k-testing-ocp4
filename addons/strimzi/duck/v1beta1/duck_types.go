/*
Licensed to the Apache Software Foundation (ASF) under one or more
contributor license agreements.  See the NOTICE file distributed with
this work for additional information regarding copyright ownership.
The ASF licenses this file to You under the Apache License, Version 2.0
(the "License"); you may not use this file except in compliance with
the License.  You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

// Package duck contains duck-types for accessing Strimzi resources
package v1beta1

import metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"

const (
	StrimziGroup            = "kafka.strimzi.io"
	StrimziVersion          = "v1beta1"
	StrimziKindTopic        = "KafkaTopic"
	StrimziKindKafkaCluster = "Kafka"

	StrimziKafkaClusterLabel = "strimzi.io/cluster"

	StrimziListenerTypePlain = "plain"
)

// +kubebuilder:object:root=true
// +genclient
// +genclient:onlyVerbs=get,list,watch
// +genclient:noStatus

// KafkaTopic is the duck of a KafkaTopic
type KafkaTopic struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`
}

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object
// KafkaTopicList contains a list of KafkaTopic
type KafkaTopicList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	Items           []KafkaTopic `json:"items"`
}

// +kubebuilder:object:root=true
// +genclient
// +genclient:onlyVerbs=get,list,watch
// +genclient:noStatus

// Kafka is the duck of a Kafka
type Kafka struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Status KafkaStatus `json:"status,omitempty"`
}

// KafkaStatus contains the relevant info of the Kafka status
type KafkaStatus struct {
	Listeners []KafkaStatusListener `json:"listeners,omitempty"`
}

// KafkaStatusListener contains listener information
type KafkaStatusListener struct {
	BootstrapServers string `json:"bootstrapServers,omitempty"`
	Type             string `json:"type,omitempty"`
}

// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object
// KafkaList contains a list of Kafka
type KafkaList struct {
	metav1.TypeMeta `json:",inline"`
	metav1.ListMeta `json:"metadata,omitempty"`
	Items           []Kafka `json:"items"`
}