#ifdef __cplusplus
extern "C"{
#endif

vsi_nn_graph_t *vnn_CreateNeuralNetwork(const char *data_file_name);
vsi_status vnn_PreProcessNeuralNetwork(vsi_nn_graph_t *graph, int argc, char** argv);
vsi_status vnn_VerifyGraph(vsi_nn_graph_t *graph);
vsi_status vnn_ProcessGraph(vsi_nn_graph_t *graph);
void vnn_ReleaseNeuralNetwork(vsi_nn_graph_t *graph );
vsi_status vnn_PostProcessNeuralNetwork(vsi_nn_graph_t *graph);

#ifdef __cplusplus
}
#endif
