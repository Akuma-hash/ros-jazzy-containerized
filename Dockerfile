FROM osrf/ros:jazzy-desktop-full

# Esse trecho comentado tem a função de ser usado em conjunto com o "devcontainer"
# Create the user
#ARG USERNAME=USERNAME
#ARG USER_UID=1000
#ARG USER_GID=$USER_UID

# Delete user if it exists in container (e.g Ubuntu Noble: ubuntu)
#RUN if id -u $USER_UID ; then userdel `id -un $USER_UID` ; fi

# Create the user
#RUN groupadd --gid $USER_GID $USERNAME \
#    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
#    && apt-get update \
#    && apt-get install -y sudo \
#    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
#    && chmod 0440 /etc/sudoers.d/$USERNAME

# atualiza os pacotes 
RUN apt-get update && apt-get upgrade -y


RUN apt-get install -y python3-pip python3-venv # como o jazzy utiliza uma versão superior ao ubuntu 20.0, ou usamos ambiente vistuais para instalar as dependencias com o pip
						# ou instalamos diretamente como o gerenciador de pacotes do ubuntu. Eu optei pelo amviente virtual  
RUN python3 -m venv /opt/venv  # cria um ambiente virtual 
ENV PATH="/opt/venv/bin:$PATH"    

RUN apt-get install -y   \
	ros-jazzy-ros-gz \
	ros-jazzy-joint-state-publisher-gui \
	ros-jazzy-cv-bridge \
	ros-jazzy-image-transport \
	ros-jazzy-tf-transformations \
	ros-jazzy-rviz2 \
	python3-opencv \
	libopencv-dev \
	&& rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir numpy scipy opencv-python

# Variáveis de ambiente para localizar modelos e mundos
ENV GZ_SIM_RESOURCE_PATH=/root/gazeboSim/sdf_world
ENV GAZEBO_MODEL_PATH=/root/gazeboSim/models
ENV ROS_DISTRO=jazzy

# Ativa o ROS no bash
SHELL ["/bin/bash", "-c"]
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> ~/.bashrc
