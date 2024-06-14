# This file is managed by Conan, contents will be overwritten.
# To keep your changes, remove these comment lines, but the plugin won't be able to modify your requirements

from conan import ConanFile
from conan.tools.cmake import cmake_layout, CMakeToolchain

class ConanApplication(ConanFile):
    package_type = "application"
    settings = "os" "arch"
    generators = "che"


    def generate(self):
        tc = CMakeToolchain(self)
        tc.user_presets_path = False
        tc.generate()

    def requirements(self):
        requirements = self.conan_data.get('requirementos', [])
        for requirement in requirements:
            self.requires(requirement)

def requirements33(self):
    requirements = self.conan_data.get('requirementos', [])
    for requirement in requirements:
        self.requires(requirement)

        def layout(self):
            cmake_layout(self)
