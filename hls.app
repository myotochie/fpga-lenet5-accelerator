<project xmlns="com.autoesl.autopilot.project" name="Lenet_RTL_test" top="top_A" projectType="C/C++">
    <includePaths/>
    <libraryPaths/>
    <Simulation>
        <SimFlow name="csim" csimMode="0" lastCsimMode="0"/>
    </Simulation>
    <files xmlns="">
        <file name="Lenet_RTL_test/lenet_conv1_only.cpp" sc="0" tb="false" cflags="" csimflags="" blackbox="false"/>
        <file name="Lenet_RTL_test/lenet_inderence.cpp" sc="0" tb="false" cflags="" csimflags="" blackbox="false"/>
        <file name="Lenet_RTL_test/lenet_params_int8.h" sc="0" tb="false" cflags="" csimflags="" blackbox="false"/>
        <file name="Lenet_RTL_test/lenet_qparams_min.h" sc="0" tb="false" cflags="" csimflags="" blackbox="false"/>
        <file name="../tb_conv1_maxpool.cpp" sc="0" tb="1" cflags="-Wno-unknown-pragmas" csimflags="" blackbox="false"/>
    </files>
    <solutions xmlns="">
        <solution name="solution1" status="active"/>
    </solutions>
</project>

