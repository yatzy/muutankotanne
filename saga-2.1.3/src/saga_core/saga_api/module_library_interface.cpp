/**********************************************************
 * Version $Id: module_library_interface.cpp 2251 2014-09-24 15:46:10Z oconrad $
 *********************************************************/

///////////////////////////////////////////////////////////
//                                                       //
//                         SAGA                          //
//                                                       //
//      System for Automated Geoscientific Analyses      //
//                                                       //
//           Application Programming Interface           //
//                                                       //
//                  Library: SAGA_API                    //
//                                                       //
//-------------------------------------------------------//
//                                                       //
//             module_library_interface.cpp              //
//                                                       //
//          Copyright (C) 2005 by Olaf Conrad            //
//                                                       //
//-------------------------------------------------------//
//                                                       //
// This file is part of 'SAGA - System for Automated     //
// Geoscientific Analyses'.                              //
//                                                       //
// This library is free software; you can redistribute   //
// it and/or modify it under the terms of the GNU Lesser //
// General Public License as published by the Free       //
// Software Foundation, version 2.1 of the License.      //
//                                                       //
// This library is distributed in the hope that it will  //
// be useful, but WITHOUT ANY WARRANTY; without even the //
// implied warranty of MERCHANTABILITY or FITNESS FOR A  //
// PARTICULAR PURPOSE. See the GNU Lesser General Public //
// License for more details.                             //
//                                                       //
// You should have received a copy of the GNU Lesser     //
// General Public License along with this program; if    //
// not, write to the Free Software Foundation, Inc.,     //
// 51 Franklin Street, 5th Floor, Boston, MA 02110-1301, //
// USA.                                                  //
//                                                       //
//-------------------------------------------------------//
//                                                       //
//    contact:    Olaf Conrad                            //
//                Institute of Geography                 //
//                University of Goettingen               //
//                Goldschmidtstr. 5                      //
//                37077 Goettingen                       //
//                Germany                                //
//                                                       //
//    e-mail:     oconrad@saga-gis.org                   //
//                                                       //
///////////////////////////////////////////////////////////

//---------------------------------------------------------


///////////////////////////////////////////////////////////
//														 //
//														 //
//														 //
///////////////////////////////////////////////////////////

//---------------------------------------------------------
#include "module.h"


///////////////////////////////////////////////////////////
//														 //
//														 //
//														 //
///////////////////////////////////////////////////////////

//---------------------------------------------------------
CSG_Module_Library_Interface::CSG_Module_Library_Interface(void)
{
	m_nModules	= 0;
	m_Modules	= NULL;
}

//---------------------------------------------------------
CSG_Module_Library_Interface::~CSG_Module_Library_Interface(void)
{
	if( m_Modules && m_nModules > 0 )
	{
		for(int i=0; i<m_nModules; i++)
		{
			if( m_Modules[i] )
			{
				delete(m_Modules[i]);
			}
		}

		SG_Free(m_Modules);
	}
}


///////////////////////////////////////////////////////////
//														 //
//														 //
//														 //
///////////////////////////////////////////////////////////

//---------------------------------------------------------
void CSG_Module_Library_Interface::Set_Info(int ID, const CSG_String &Info)
{
	if( ID <= MLB_INFO_User )
	{
		m_Info[ID]	= SG_Translate(Info);
	}
}

//---------------------------------------------------------
const CSG_String & CSG_Module_Library_Interface::Get_Info(int ID)
{
	return( m_Info[ID] );
}


///////////////////////////////////////////////////////////
//														 //
//														 //
//														 //
///////////////////////////////////////////////////////////

//---------------------------------------------------------
int CSG_Module_Library_Interface::Get_Count(void)
{
	return( m_nModules );
}

//---------------------------------------------------------
bool CSG_Module_Library_Interface::Add_Module(CSG_Module *pModule, int ID)
{
	if( pModule )
	{
		if( pModule == MLB_INTERFACE_SKIP_MODULE )
		{
			pModule	= NULL;
		}
		else
		{
			pModule->m_ID.Printf(SG_T("%d"), ID);
			pModule->m_Library		= Get_Info(MLB_INFO_Library);
			pModule->m_File_Name	= Get_Info(MLB_INFO_File);
		}

		m_Modules				= (CSG_Module **)SG_Realloc(m_Modules, (m_nModules + 1) * sizeof(CSG_Module *));
		m_Modules[m_nModules++]	= pModule;

		return( true );
	}

	return( false );
}

//---------------------------------------------------------
CSG_Module * CSG_Module_Library_Interface::Get_Module(int iModule)
{
	if( iModule >= 0 && iModule < m_nModules )
	{
		return( m_Modules[iModule] );
	}

	return( NULL );
}


///////////////////////////////////////////////////////////
//														 //
//														 //
//														 //
///////////////////////////////////////////////////////////

//---------------------------------------------------------
void CSG_Module_Library_Interface::Set_File_Name(const CSG_String &File_Name)
{
	m_Info[MLB_INFO_File]	= SG_File_Get_Path_Absolute(File_Name);

	CSG_String	Library		= SG_File_Get_Name(File_Name, false);

#if !defined(_SAGA_MSW)
	if( Library.Find("lib") == 0 )
	{
		Library	= Library.Right(Library.Length() - 3);
	}
#endif

	m_Info[MLB_INFO_Library]	= Library;
}


///////////////////////////////////////////////////////////
//														 //
//														 //
//														 //
///////////////////////////////////////////////////////////

//---------------------------------------------------------