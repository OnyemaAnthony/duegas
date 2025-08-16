import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duegas/features/app/app_provider.dart';
import 'package:duegas/features/app/app_repository.dart';
import 'package:duegas/features/app/screens/navigation_screen.dart';
import 'package:duegas/features/auth/auth_provider.dart';
import 'package:duegas/features/auth/auth_repo.dart';
import 'package:duegas/features/auth/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCiE7vB7f7T-NEeotsO42EwaIzbD5DPvnA",
        authDomain: "duenergy-2c177.firebaseapp.com",
        projectId: "duenergy-2c177",
        storageBucket: "duenergy-2c177.firebasestorage.app",
        messagingSenderId: "557671459064",
        appId: "1:557671459064:web:64965d37307b0fa8d6730d",
        measurementId: "G-HS3R0KHF18"),
  );
  // await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthRepository>(
          create: (_) => AuthRepository(
            firebaseAuth: FirebaseAuth.instance,
            firestore: FirebaseFirestore.instance,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthenticationProvider(
            context.read<AuthRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => AppProvider(
            repository: AppRepository(firestore: FirebaseFirestore.instance),
          ),
        ),
        StreamProvider<User?>(
          create: (context) => context.read<AuthRepository>().authStateChanges,
          initialData: null,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        primaryColor: Colors.black,
      ),
      home: user == null ? const LoginScreen() : const NavigationScreen(),
    );
  }
}






<?xml version="1.0" encoding="utf-8"?>
<Project DefaultTargets="Build" ToolsVersion="16.0" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
<PropertyGroup>
<PreferredToolArchitecture>x64</PreferredToolArchitecture>
</PropertyGroup>
<ItemGroup Label="ProjectConfigurations">
<ProjectConfiguration Include="Debug|x64">
<Configuration>Debug</Configuration>
<Platform>x64</Platform>
</ProjectConfiguration>
<ProjectConfiguration Include="Profile|x64">
<Configuration>Profile</Configuration>
<Platform>x64</Platform>
</ProjectConfiguration>
<ProjectConfiguration Include="Release|x64">
<Configuration>Release</Configuration>
<Platform>x64</Platform>
</ProjectConfiguration>
</ItemGroup>
<PropertyGroup Label="Globals">
    <ProjectGuid>{185E35BA-92F2-3D0A-9188-51ED9A63EA59}</ProjectGuid>
<WindowsTargetPlatformVersion>10.0.19041.0</WindowsTargetPlatformVersion>
<Keyword>Win32Proj</Keyword>
<Platform>x64</Platform>
<ProjectName>firebase_auth_plugin</ProjectName>
<VCProjectUpgraderObjectName>NoUpgrade</VCProjectUpgraderObjectName>
</PropertyGroup>
<Import Project="$(VCTargetsPath)\Microsoft.Cpp.Default.props" />
<PropertyGroup Condition="'$(Configuration)|$(Platform)'=='Debug|x64'" Label="Configuration">
<ConfigurationType>StaticLibrary</ConfigurationType>
<CharacterSet>Unicode</CharacterSet>
<PlatformToolset>v142</PlatformToolset>
</PropertyGroup>
<PropertyGroup Condition="'$(Configuration)|$(Platform)'=='Profile|x64'" Label="Configuration">
<ConfigurationType>StaticLibrary</ConfigurationType>
<CharacterSet>Unicode</CharacterSet>
<PlatformToolset>v142</PlatformToolset>
</PropertyGroup>
<PropertyGroup Condition="'$(Configuration)|$(Platform)'=='Release|x64'" Label="Configuration">
<ConfigurationType>StaticLibrary</ConfigurationType>
<CharacterSet>Unicode</CharacterSet>
<PlatformToolset>v142</PlatformToolset>
</PropertyGroup>
<Import Project="$(VCTargetsPath)\Microsoft.Cpp.props" />
<ImportGroup Label="ExtensionSettings">
</ImportGroup>
<ImportGroup Label="PropertySheets">
<Import Project="$(UserRootDir)\Microsoft.Cpp.$(Platform).user.props" Condition="exists('$(UserRootDir)\Microsoft.Cpp.$(Platform).user.props')" Label="LocalAppDataPlatform" />
</ImportGroup>
<PropertyGroup Label="UserMacros" />
<PropertyGroup>
<_ProjectFileVersion>10.0.20506.1</_ProjectFileVersion>
<OutDir Condition="'$(Configuration)|$(Platform)'=='Debug|x64'">C:\Users\Work\Desktop\learning dart\duegas\build\windows\x64\plugins\firebase_auth\Debug\</OutDir>
<IntDir Condition="'$(Configuration)|$(Platform)'=='Debug|x64'">firebase_auth_plugin.dir\Debug\</IntDir>
<TargetName Condition="'$(Configuration)|$(Platform)'=='Debug|x64'">firebase_auth_plugin</TargetName>
<TargetExt Condition="'$(Configuration)|$(Platform)'=='Debug|x64'">.lib</TargetExt>
<OutDir Condition="'$(Configuration)|$(Platform)'=='Profile|x64'">C:\Users\Work\Desktop\learning dart\duegas\build\windows\x64\plugins\firebase_auth\Profile\</OutDir>
<IntDir Condition="'$(Configuration)|$(Platform)'=='Profile|x64'">firebase_auth_plugin.dir\Profile\</IntDir>
<TargetName Condition="'$(Configuration)|$(Platform)'=='Profile|x64'">firebase_auth_plugin</TargetName>
<TargetExt Condition="'$(Configuration)|$(Platform)'=='Profile|x64'">.lib</TargetExt>
<OutDir Condition="'$(Configuration)|$(Platform)'=='Release|x64'">C:\Users\Work\Desktop\learning dart\duegas\build\windows\x64\plugins\firebase_auth\Release\</OutDir>
<IntDir Condition="'$(Configuration)|$(Platform)'=='Release|x64'">firebase_auth_plugin.dir\Release\</IntDir>
<TargetName Condition="'$(Configuration)|$(Platform)'=='Release|x64'">firebase_auth_plugin</TargetName>
<TargetExt Condition="'$(Configuration)|$(Platform)'=='Release|x64'">.lib</TargetExt>
</PropertyGroup>
<ItemDefinitionGroup Condition="'$(Configuration)|$(Platform)'=='Debug|x64'">
<ClCompile>
<AdditionalIncludeDirectories>C:\Users\Work\Desktop\learning dart\duegas\build\windows\x64\generated;C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral\.plugin_symlinks\firebase_core\windows\include;C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral;C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral\cpp_client_wrapper\include;C:\Users\Work\Desktop\learning dart\duegas\build\windows\x64\extracted\firebase_cpp_sdk_windows\include;%(AdditionalIncludeDirectories)</AdditionalIncludeDirectories>
<AssemblerListingLocation>$(IntDir)</AssemblerListingLocation>
<BasicRuntimeChecks>EnableFastChecks</BasicRuntimeChecks>
<DebugInformationFormat>ProgramDatabase</DebugInformationFormat>
<DisableSpecificWarnings>"4100"</DisableSpecificWarnings>
<ExceptionHandling>Sync</ExceptionHandling>
<InlineFunctionExpansion>Disabled</InlineFunctionExpansion>
<LanguageStandard>stdcpp17</LanguageStandard>
<Optimization>Disabled</Optimization>
<PrecompiledHeader>NotUsing</PrecompiledHeader>
<RuntimeLibrary>MultiThreadedDebugDLL</RuntimeLibrary>
<RuntimeTypeInfo>true</RuntimeTypeInfo>
<TreatWarningAsError>true</TreatWarningAsError>
<UseFullPaths>false</UseFullPaths>
<WarningLevel>Level4</WarningLevel>
<PreprocessorDefinitions>_CRT_SECURE_NO_WARNINGS;WIN32;_WINDOWS;_HAS_EXCEPTIONS=0;_DEBUG;FLUTTER_PLUGIN_IMPL;INTERNAL_EXPERIMENTAL=1;UNICODE;_UNICODE;CMAKE_INTDIR="Debug";%(PreprocessorDefinitions)</PreprocessorDefinitions>
<ObjectFileName>$(IntDir)</ObjectFileName>
</ClCompile>
<ResourceCompile>
<PreprocessorDefinitions>WIN32;_DEBUG;_WINDOWS;_HAS_EXCEPTIONS=0;FLUTTER_PLUGIN_IMPL;INTERNAL_EXPERIMENTAL=1;UNICODE;_UNICODE;CMAKE_INTDIR=\"Debug\";%(PreprocessorDefinitions)</PreprocessorDefinitions>
<AdditionalIncludeDirectories>C:\Users\Work\Desktop\learning dart\duegas\build\windows\x64\generated;C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral\.plugin_symlinks\firebase_core\windows\include;C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral;C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral\cpp_client_wrapper\include;C:\Users\Work\Desktop\learning dart\duegas\build\windows\x64\extracted\firebase_cpp_sdk_windows\include;%(AdditionalIncludeDirectories)</AdditionalIncludeDirectories>
</ResourceCompile>
<Midl>
<AdditionalIncludeDirectories>C:\Users\Work\Desktop\learning dart\duegas\build\windows\x64\generated;C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral\.plugin_symlinks\firebase_core\windows\include;C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral;C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral\cpp_client_wrapper\include;C:\Users\Work\Desktop\learning dart\duegas\build\windows\x64\extracted\firebase_cpp_sdk_windows\include;%(AdditionalIncludeDirectories)</AdditionalIncludeDirectories>
<OutputDirectory>$(ProjectDir)/$(IntDir)</OutputDirectory>
<HeaderFileName>%(Filename).h</HeaderFileName>
<TypeLibraryName>%(Filename).tlb</TypeLibraryName>
<InterfaceIdentifierFileName>%(Filename)_i.c</InterfaceIdentifierFileName>
<ProxyFileName>%(Filename)_p.c</ProxyFileName>
</Midl>
<Lib>
<AdditionalOptions>%(AdditionalOptions) /machine:x64</AdditionalOptions>
</Lib>
</ItemDefinitionGroup>
<ItemDefinitionGroup Condition="'$(Configuration)|$(Platform)'=='Profile|x64'">
<ClCompile>
<AdditionalIncludeDirectories>C:\Users\Work\Desktop\learning dart\duegas\build\windows\x64\generated;C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral\.plugin_symlinks\firebase_core\windows\include;C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral;C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral\cpp_client_wrapper\include;C:\Users\Work\Desktop\learning dart\duegas\build\windows\x64\extracted\firebase_cpp_sdk_windows\include;%(AdditionalIncludeDirectories)</AdditionalIncludeDirectories>
<AssemblerListingLocation>$(IntDir)</AssemblerListingLocation>
<DisableSpecificWarnings>"4100"</DisableSpecificWarnings>
<ExceptionHandling>Sync</ExceptionHandling>
<InlineFunctionExpansion>AnySuitable</InlineFunctionExpansion>
<LanguageStandard>stdcpp17</LanguageStandard>
<Optimization>MaxSpeed</Optimization>
<PrecompiledHeader>NotUsing</PrecompiledHeader>
<RuntimeLibrary>MultiThreadedDLL</RuntimeLibrary>
<RuntimeTypeInfo>true</RuntimeTypeInfo>
<TreatWarningAsError>true</TreatWarningAsError>
<UseFullPaths>false</UseFullPaths>
<WarningLevel>Level4</WarningLevel>
<PreprocessorDefinitions>_CRT_SECURE_NO_WARNINGS;WIN32;_WINDOWS;NDEBUG;_HAS_EXCEPTIONS=0;FLUTTER_PLUGIN_IMPL;INTERNAL_EXPERIMENTAL=1;UNICODE;_UNICODE;CMAKE_INTDIR="Profile";%(PreprocessorDefinitions)</PreprocessorDefinitions>
<ObjectFileName>$(IntDir)</ObjectFileName>
<DebugInformationFormat>
</DebugInformationFormat>
</ClCompile>
<ResourceCompile>
<PreprocessorDefinitions>WIN32;_WINDOWS;NDEBUG;_HAS_EXCEPTIONS=0;FLUTTER_PLUGIN_IMPL;INTERNAL_EXPERIMENTAL=1;UNICODE;_UNICODE;CMAKE_INTDIR=\"Profile\";%(PreprocessorDefinitions)</PreprocessorDefinitions>
<AdditionalIncludeDirectories>C:\Users\Work\Desktop\learning dart\duegas\build\windows\x64\generated;C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral\.plugin_symlinks\firebase_core\windows\include;C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral;C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral\cpp_client_wrapper\include;C:\Users\Work\Desktop\learning dart\duegas\build\windows\x64\extracted\firebase_cpp_sdk_windows\include;%(AdditionalIncludeDirectories)</AdditionalIncludeDirectories>
</ResourceCompile>
<Midl>
<AdditionalIncludeDirectories>C:\Users\Work\Desktop\learning dart\duegas\build\windows\x64\generated;C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral\.plugin_symlinks\firebase_core\windows\include;C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral;C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral\cpp_client_wrapper\include;C:\Users\Work\Desktop\learning dart\duegas\build\windows\x64\extracted\firebase_cpp_sdk_windows\include;%(AdditionalIncludeDirectories)</AdditionalIncludeDirectories>
<OutputDirectory>$(ProjectDir)/$(IntDir)</OutputDirectory>
<HeaderFileName>%(Filename).h</HeaderFileName>
<TypeLibraryName>%(Filename).tlb</TypeLibraryName>
<InterfaceIdentifierFileName>%(Filename)_i.c</InterfaceIdentifierFileName>
<ProxyFileName>%(Filename)_p.c</ProxyFileName>
</Midl>
<Lib>
<AdditionalOptions>%(AdditionalOptions) /machine:x64</AdditionalOptions>
</Lib>
</ItemDefinitionGroup>
<ItemDefinitionGroup Condition="'$(Configuration)|$(Platform)'=='Release|x64'">
<ClCompile>
<AdditionalIncludeDirectories>C:\Users\Work\Desktop\learning dart\duegas\build\windows\x64\generated;C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral\.plugin_symlinks\firebase_core\windows\include;C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral;C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral\cpp_client_wrapper\include;C:\Users\Work\Desktop\learning dart\duegas\build\windows\x64\extracted\firebase_cpp_sdk_windows\include;%(AdditionalIncludeDirectories)</AdditionalIncludeDirectories>
<AssemblerListingLocation>$(IntDir)</AssemblerListingLocation>
<DisableSpecificWarnings>"4100"</DisableSpecificWarnings>
<ExceptionHandling>Sync</ExceptionHandling>
<InlineFunctionExpansion>AnySuitable</InlineFunctionExpansion>
<LanguageStandard>stdcpp17</LanguageStandard>
<Optimization>MaxSpeed</Optimization>
<PrecompiledHeader>NotUsing</PrecompiledHeader>
<RuntimeLibrary>MultiThreadedDLL</RuntimeLibrary>
<RuntimeTypeInfo>true</RuntimeTypeInfo>
<TreatWarningAsError>true</TreatWarningAsError>
<UseFullPaths>false</UseFullPaths>
<WarningLevel>Level4</WarningLevel>
<PreprocessorDefinitions>_CRT_SECURE_NO_WARNINGS;WIN32;_WINDOWS;NDEBUG;_HAS_EXCEPTIONS=0;FLUTTER_PLUGIN_IMPL;INTERNAL_EXPERIMENTAL=1;UNICODE;_UNICODE;CMAKE_INTDIR="Release";%(PreprocessorDefinitions)</PreprocessorDefinitions>
<ObjectFileName>$(IntDir)</ObjectFileName>
<DebugInformationFormat>
</DebugInformationFormat>
</ClCompile>
<ResourceCompile>
<PreprocessorDefinitions>WIN32;_WINDOWS;NDEBUG;_HAS_EXCEPTIONS=0;FLUTTER_PLUGIN_IMPL;INTERNAL_EXPERIMENTAL=1;UNICODE;_UNICODE;CMAKE_INTDIR=\"Release\";%(PreprocessorDefinitions)</PreprocessorDefinitions>
<AdditionalIncludeDirectories>C:\Users\Work\Desktop\learning dart\duegas\build\windows\x64\generated;C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral\.plugin_symlinks\firebase_core\windows\include;C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral;C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral\cpp_client_wrapper\include;C:\Users\Work\Desktop\learning dart\duegas\build\windows\x64\extracted\firebase_cpp_sdk_windows\include;%(AdditionalIncludeDirectories)</AdditionalIncludeDirectories>
</ResourceCompile>
<Midl>
<AdditionalIncludeDirectories>C:\Users\Work\Desktop\learning dart\duegas\build\windows\x64\generated;C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral\.plugin_symlinks\firebase_core\windows\include;C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral;C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral\cpp_client_wrapper\include;C:\Users\Work\Desktop\learning dart\duegas\build\windows\x64\extracted\firebase_cpp_sdk_windows\include;%(AdditionalIncludeDirectories)</AdditionalIncludeDirectories>
<OutputDirectory>$(ProjectDir)/$(IntDir)</OutputDirectory>
<HeaderFileName>%(Filename).h</HeaderFileName>
<TypeLibraryName>%(Filename).tlb</TypeLibraryName>
<InterfaceIdentifierFileName>%(Filename)_i.c</InterfaceIdentifierFileName>
<ProxyFileName>%(Filename)_p.c</ProxyFileName>
</Midl>
<Lib>
<AdditionalOptions>%(AdditionalOptions) /machine:x64</AdditionalOptions>
</Lib>
</ItemDefinitionGroup>
<ItemGroup>
<CustomBuild Include="C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral\.plugin_symlinks\firebase_auth\windows\CMakeLists.txt">
<StdOutEncoding>UTF-8</StdOutEncoding>
<Message Condition="'$(Configuration)|$(Platform)'=='Debug|x64'">Building Custom Rule C:/Users/Work/Desktop/learning dart/duegas/windows/flutter/ephemeral/.plugin_symlinks/firebase_auth/windows/CMakeLists.txt</Message>
<Command Condition="'$(Configuration)|$(Platform)'=='Debug|x64'">setlocal
"C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe" "-SC:/Users/Work/Desktop/learning dart/duegas/windows" "-BC:/Users/Work/Desktop/learning dart/duegas/build/windows/x64" --check-stamp-file "C:/Users/Work/Desktop/learning dart/duegas/build/windows/x64/plugins/firebase_auth/CMakeFiles/generate.stamp"
if %errorlevel% neq 0 goto :cmEnd
    :cmEnd
endlocal &amp; call :cmErrorLevel %errorlevel% &amp; goto :cmDone
    :cmErrorLevel
exit /b %1
    :cmDone
if %errorlevel% neq 0 goto :VCEnd</Command>
<AdditionalInputs Condition="'$(Configuration)|$(Platform)'=='Debug|x64'">C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral\.plugin_symlinks\firebase_auth\windows\plugin_version.h.in;%(AdditionalInputs)</AdditionalInputs>
<Outputs Condition="'$(Configuration)|$(Platform)'=='Debug|x64'">C:\Users\Work\Desktop\learning dart\duegas\build\windows\x64\plugins\firebase_auth\CMakeFiles\generate.stamp</Outputs>
<LinkObjects Condition="'$(Configuration)|$(Platform)'=='Debug|x64'">false</LinkObjects>
<Message Condition="'$(Configuration)|$(Platform)'=='Profile|x64'">Building Custom Rule C:/Users/Work/Desktop/learning dart/duegas/windows/flutter/ephemeral/.plugin_symlinks/firebase_auth/windows/CMakeLists.txt</Message>
<Command Condition="'$(Configuration)|$(Platform)'=='Profile|x64'">setlocal
"C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe" "-SC:/Users/Work/Desktop/learning dart/duegas/windows" "-BC:/Users/Work/Desktop/learning dart/duegas/build/windows/x64" --check-stamp-file "C:/Users/Work/Desktop/learning dart/duegas/build/windows/x64/plugins/firebase_auth/CMakeFiles/generate.stamp"
if %errorlevel% neq 0 goto :cmEnd
    :cmEnd
endlocal &amp; call :cmErrorLevel %errorlevel% &amp; goto :cmDone
    :cmErrorLevel
exit /b %1
    :cmDone
if %errorlevel% neq 0 goto :VCEnd</Command>
<AdditionalInputs Condition="'$(Configuration)|$(Platform)'=='Profile|x64'">C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral\.plugin_symlinks\firebase_auth\windows\plugin_version.h.in;%(AdditionalInputs)</AdditionalInputs>
<Outputs Condition="'$(Configuration)|$(Platform)'=='Profile|x64'">C:\Users\Work\Desktop\learning dart\duegas\build\windows\x64\plugins\firebase_auth\CMakeFiles\generate.stamp</Outputs>
<LinkObjects Condition="'$(Configuration)|$(Platform)'=='Profile|x64'">false</LinkObjects>
<Message Condition="'$(Configuration)|$(Platform)'=='Release|x64'">Building Custom Rule C:/Users/Work/Desktop/learning dart/duegas/windows/flutter/ephemeral/.plugin_symlinks/firebase_auth/windows/CMakeLists.txt</Message>
<Command Condition="'$(Configuration)|$(Platform)'=='Release|x64'">setlocal
"C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe" "-SC:/Users/Work/Desktop/learning dart/duegas/windows" "-BC:/Users/Work/Desktop/learning dart/duegas/build/windows/x64" --check-stamp-file "C:/Users/Work/Desktop/learning dart/duegas/build/windows/x64/plugins/firebase_auth/CMakeFiles/generate.stamp"
if %errorlevel% neq 0 goto :cmEnd
    :cmEnd
endlocal &amp; call :cmErrorLevel %errorlevel% &amp; goto :cmDone
    :cmErrorLevel
exit /b %1
    :cmDone
if %errorlevel% neq 0 goto :VCEnd</Command>
<AdditionalInputs Condition="'$(Configuration)|$(Platform)'=='Release|x64'">C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral\.plugin_symlinks\firebase_auth\windows\plugin_version.h.in;%(AdditionalInputs)</AdditionalInputs>
<Outputs Condition="'$(Configuration)|$(Platform)'=='Release|x64'">C:\Users\Work\Desktop\learning dart\duegas\build\windows\x64\plugins\firebase_auth\CMakeFiles\generate.stamp</Outputs>
<LinkObjects Condition="'$(Configuration)|$(Platform)'=='Release|x64'">false</LinkObjects>
</CustomBuild>
</ItemGroup>
<ItemGroup>
<ClInclude Include="C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral\.plugin_symlinks\firebase_auth\windows\include\firebase_auth\firebase_auth_plugin_c_api.h" />
<ClCompile Include="C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral\.plugin_symlinks\firebase_auth\windows\firebase_auth_plugin_c_api.cpp" />
<ClCompile Include="C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral\.plugin_symlinks\firebase_auth\windows\firebase_auth_plugin.cpp" />
<ClInclude Include="C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral\.plugin_symlinks\firebase_auth\windows\firebase_auth_plugin.h" />
<ClCompile Include="C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral\.plugin_symlinks\firebase_auth\windows\messages.g.cpp" />
<ClInclude Include="C:\Users\Work\Desktop\learning dart\duegas\windows\flutter\ephemeral\.plugin_symlinks\firebase_auth\windows\messages.g.h" />
<ClInclude Include="C:\Users\Work\Desktop\learning dart\duegas\build\windows\x64\generated\firebase_auth\plugin_version.h" />
</ItemGroup>
<ItemGroup>
<ProjectReference Include="C:\Users\Work\Desktop\learning dart\duegas\build\windows\x64\ZERO_CHECK.vcxproj">
<Project>{1C2F7C8E-8ADF-3CA2-8958-772C842033C2}</Project>
<Name>ZERO_CHECK</Name>
<ReferenceOutputAssembly>false</ReferenceOutputAssembly>
<CopyToOutputDirectory>Never</CopyToOutputDirectory>
</ProjectReference>
<ProjectReference Include="C:\Users\Work\Desktop\learning dart\duegas\build\windows\x64\plugins\firebase_core\firebase_core_plugin.vcxproj">
<Project>{6AA4EFD8-579F-30AD-9D97-7C26714F4AEB}</Project>
<Name>firebase_core_plugin</Name>
</ProjectReference>
<ProjectReference Include="C:\Users\Work\Desktop\learning dart\duegas\build\windows\x64\flutter\flutter_assemble.vcxproj">
<Project>{AADBD836-8178-33A4-862C-175AD88FE9C8}</Project>
<Name>flutter_assemble</Name>
<ReferenceOutputAssembly>false</ReferenceOutputAssembly>
<CopyToOutputDirectory>Never</CopyToOutputDirectory>
</ProjectReference>
<ProjectReference Include="C:\Users\Work\Desktop\learning dart\duegas\build\windows\x64\flutter\flutter_wrapper_plugin.vcxproj">
<Project>{AFBDAD26-6640-3BAE-86A9-B30A4FCC53E7}</Project>
<Name>flutter_wrapper_plugin</Name>
</ProjectReference>
</ItemGroup>
<Import Project="$(VCTargetsPath)\Microsoft.Cpp.targets" />
<ImportGroup Label="ExtensionTargets">
</ImportGroup>
</Project>