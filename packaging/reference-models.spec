%define vivante_support 1

%ifarch %arm aarch64
%define vivante_support 1
%endif

Name:		reference-models
Summary:	Model package for case code of Vivante NPU model
Version:	1.0.0
Release:	0
Group:		Applications/Multimedia
Packager:	Geunsik Lim <geunsik.lim@samsung.com>
License:	Apache-2.0
Source0:	%{name}-%{version}.tar.gz
Source1001:	%{name}.manifest

Requires:	    nnstreamer
BuildRequires:	pkgconfig(nnstreamer)

# common requirements
BuildRequires:	meson >= 0.50.0
BuildRequires:	ninja
BuildRequires:	gstreamer-devel
BuildRequires:	gst-plugins-base-devel
BuildRequires:	glib2-devel
BuildRequires:	glibc
BuildRequires:	libjpeg libjpeg-devel

# for Vivante NPU
%if 0%{?vivante_support}
BuildRequires:  pkgconfig(opencv)
BuildRequires:  pkgconfig(ovxlib)
BuildRequires:  pkgconfig(amlogic-vsi-npu-sdk)
%endif

%description
This package consists of the models that is used by case code
on VIM3/Vivante board.


# Support vivante subplugin
%if 0%{?vivante_support}
%define enable_vivante -Denable-vivante=true
%else
%define enable_vivante -Denable-vivante=false
%endif

%prep
%setup -q
cp %{SOURCE1001} .

%build

meson --buildtype=plain --prefix=%{_prefix} --sysconfdir=%{_sysconfdir} --libdir=%{_libdir} --includedir=%{_includedir} -Denable-tizen=true %{enable_vivante}  build

ninja -C build %{?_smp_mflags}


%install
DESTDIR=%{buildroot} ninja -C build %{?_smp_mflags} install
mkdir -p %{buildroot}/%{_datadir}/vivante/res/
cp ./models/inceptionv3/bin_demo_deprecated/libinceptionv3.so %{buildroot}/%{_datadir}/vivante/inceptionv3/libinceptionv3_ori.so
cp ./models/inceptionv3/bin_demo_deprecated/inception_v3.nb %{buildroot}/%{_datadir}/vivante/inceptionv3/
cp ./models/inceptionv3/bin_demo_deprecated/imagenet_slim_labels.txt %{buildroot}/%{_datadir}/vivante/inceptionv3/
cp ./models/inceptionv3/bin_demo_deprecated/goldfish_299x299.jpg %{buildroot}/%{_datadir}/vivante/res/
cp ./models/inceptionv3/bin_demo_deprecated/dog_299x299.jpg %{buildroot}/%{_datadir}/vivante/res/
cp ./models/inceptionv3/bin_demo_deprecated/sample_pizza_299x299.jpg %{buildroot}/%{_datadir}/vivante/res/

cp ./models/yolov3/bin_demo_deprecated/libyolov3.so %{buildroot}/%{_datadir}/vivante/yolov3/libyolov3_ori.so
cp ./models/yolov3/bin_demo_deprecated/yolov3.nb %{buildroot}/%{_datadir}/vivante/yolov3/
cp ./models/yolov3/bin_demo_deprecated/yolo-v3-label.txt %{buildroot}/%{_datadir}/vivante/yolov3/
cp ./models/yolov3/bin_demo_deprecated/sample_car_bicyle_dog_416x416.jpg %{buildroot}/%{_datadir}/vivante/res/
cp ./models/yolov3/bin_demo_deprecated/sample_car_bicyle_dog_786x576.jpg %{buildroot}/%{_datadir}/vivante/res/

%if 0%{?vivante_support}
%files
%manifest %{name}.manifest
/%{_datadir}/vivante/inceptionv3/libinceptionv3.so
/%{_datadir}/vivante/inceptionv3/libinceptionv3_ori.so
/%{_datadir}/vivante/inceptionv3/inception_v3.nb
/%{_datadir}/vivante/inceptionv3/imagenet_slim_labels.txt
/%{_datadir}/vivante/res/goldfish_299x299.jpg
/%{_datadir}/vivante/res/dog_299x299.jpg
/%{_datadir}/vivante/res/sample_pizza_299x299.jpg
/%{_datadir}/vivante/yolov3/libyolov3.so
/%{_datadir}/vivante/yolov3/libyolov3_ori.so
/%{_datadir}/vivante/yolov3/yolov3.nb
/%{_datadir}/vivante/yolov3/yolo-v3-label.txt
/%{_datadir}/vivante/res/sample_car_bicyle_dog_416x416.jpg
/%{_datadir}/vivante/res/sample_car_bicyle_dog_786x576.jpg
%endif


%changelog
* Fri Feb 28 2020 Geunsik Lim <geunsik.lim@samsung.com>
- Added Vivante NPU models (e.g., Yolov3, Inceptionv3).
- Added a shared library (*.so) to proceed the network models with dlopen.
