
cc = meson.get_compiler('c')

# required libraries for a linking step
libOpenVX_dep = cc.find_library('OpenVX')
libOpenVXU_dep = cc.find_library('OpenVXU')
libCLC_dep = cc.find_library('CLC')
libVSC_dep = cc.find_library('VSC')
libGAL_dep = cc.find_library('GAL')
libovxlib_dep = cc.find_library('ovxlib')
libm_dep = cc.find_library('m')
librt_dep = cc.find_library('rt')
#TODO: Currently, there are differenct version (2.2 and 2.4) of libdl library
# because of the complicated RPM repositories.
#libdl_dep = cc.find_library('dl')
libjpeg_dep = cc.find_library('jpeg')

base_deps = [
  glib_dep,
  gobject_dep,
  nnstreamer_dep
]

# Dependencies
da_deps = [
  libOpenVX_dep,
  libOpenVXU_dep,
  libCLC_dep,
  libVSC_dep,
  libGAL_dep,
  libovxlib_dep,
  libm_dep,
  librt_dep,
#  libdl_dep,
  libjpeg_dep
]

# Inceptionv3 source files
model_sources = [
  'vnn_inceptionv3.c',
  'vnn_pre_process.c',
  'vnn_post_process.c',
  'main.c'
]

# Header files for VIM3/Tizen(aarch64) board
vivante_incs = []
vivante_incs += include_directories(
  '/usr/include/dann',
  '/usr/include/ovx',
  '/usr/include/amlogic-vsi-npu-sdk'
)

# vflag = '-ldl'

# shared library
model_shared = shared_library('inceptionv3',
  model_sources,
  include_directories: vivante_incs,
  dependencies: [base_deps, da_deps],
#  link_args : vflag,
  install: true,
  install_dir: filter_subplugin_install_dir_inceptionv3
)
