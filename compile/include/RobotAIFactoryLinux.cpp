// RobotAIFactory.cpp : ���� DLL Ӧ�ó���ĵ���������
//

#include "sys/RobotAI_Interface.h"
#include "RobotAI.h"


extern "C" RobotAI_Interface* Export()
{
	return (RobotAI_Interface*)new RobotAI();
}

extern "C" void FreeRobotAIPointer(RobotAI_Interface* p)
{
	delete p;
}
