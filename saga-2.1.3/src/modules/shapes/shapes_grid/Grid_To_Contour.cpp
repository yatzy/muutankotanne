/**********************************************************
 * Version $Id: Grid_To_Contour.cpp 2305 2014-10-24 10:12:20Z oconrad $
 *********************************************************/

///////////////////////////////////////////////////////////
//                                                       //
//                         SAGA                          //
//                                                       //
//      System for Automated Geoscientific Analyses      //
//                                                       //
//                    Module Library:                    //
//                      Grid_Shapes                      //
//                                                       //
//-------------------------------------------------------//
//                                                       //
//                  Grid_To_Contour.cpp                  //
//                                                       //
//                 Copyright (C) 2003 by                 //
//                      Olaf Conrad                      //
//                                                       //
//-------------------------------------------------------//
//                                                       //
// This file is part of 'SAGA - System for Automated     //
// Geoscientific Analyses'. SAGA is free software; you   //
// can redistribute it and/or modify it under the terms  //
// of the GNU General Public License as published by the //
// Free Software Foundation; version 2 of the License.   //
//                                                       //
// SAGA is distributed in the hope that it will be       //
// useful, but WITHOUT ANY WARRANTY; without even the    //
// implied warranty of MERCHANTABILITY or FITNESS FOR A  //
// PARTICULAR PURPOSE. See the GNU General Public        //
// License for more details.                             //
//                                                       //
// You should have received a copy of the GNU General    //
// Public License along with this program; if not,       //
// write to the Free Software Foundation, Inc.,          //
// 51 Franklin Street, 5th Floor, Boston, MA 02110-1301, //
// USA.                                                  //
//                                                       //
//-------------------------------------------------------//
//                                                       //
//    e-mail:     oconrad@saga-gis.org                   //
//                                                       //
//    contact:    Olaf Conrad                            //
//                Institute of Geography                 //
//                University of Goettingen               //
//                Goldschmidtstr. 5                      //
//                37077 Goettingen                       //
//                Germany                                //
//                                                       //
///////////////////////////////////////////////////////////

//---------------------------------------------------------


///////////////////////////////////////////////////////////
//														 //
//														 //
//														 //
///////////////////////////////////////////////////////////

//---------------------------------------------------------
#include "Grid_To_Contour.h"


///////////////////////////////////////////////////////////
//														 //
//														 //
//														 //
///////////////////////////////////////////////////////////

//---------------------------------------------------------
CGrid_To_Contour::CGrid_To_Contour(void)
{
	//-----------------------------------------------------
	Set_Name		(_TL("Contour Lines from Grid"));

	Set_Author		(SG_T("(c) 2001 by O.Conrad"));

	Set_Description	(_TW(
		"Create contour lines (isolines) from grid values. "
	));


	//-----------------------------------------------------
	Parameters.Add_Grid(
		NULL, "GRID"	, _TL("Grid"),
		_TL(""),
		PARAMETER_INPUT
	);

	Parameters.Add_Shapes(
		NULL, "CONTOUR"	, _TL("Contour"),
		_TL(""),
		PARAMETER_OUTPUT
	);

	Parameters.Add_Choice(
		NULL, "VERTEX"	, _TL("Vertex Type"),
		_TL("choose vertex type for resulting contours"),
		CSG_String::Format("%s|%s|",
			SG_T("x, y"),
			SG_T("x, y, z")
		), 0
	);

	Parameters.Add_Value(
		NULL, "ZMIN"	, _TL("Minimum Contour Value"),
		_TL(""),
		PARAMETER_TYPE_Double, 0.0
	);

	Parameters.Add_Value(
		NULL, "ZMAX"	, _TL("Maximum Contour Value"),
		_TL(""),
		PARAMETER_TYPE_Double, 10000.0
	);

	Parameters.Add_Value(
		NULL, "ZSTEP"	, _TL("Equidistance"),
		_TL(""),
		PARAMETER_TYPE_Double, 10.0, 0, true
	);
}


///////////////////////////////////////////////////////////
//														 //
//														 //
//														 //
///////////////////////////////////////////////////////////

//---------------------------------------------------------
int CGrid_To_Contour::On_Parameter_Changed(CSG_Parameters *pParameters, CSG_Parameter *pParameter)
{
	if( !SG_STR_CMP(pParameter->Get_Identifier(), "GRID") && pParameter->asGrid() != NULL )
	{
		double	zStep	= pParameter->asGrid()->Get_ZRange() / 10.0;

		pParameters->Get_Parameter("ZMIN" )->Set_Value(pParameter->asGrid()->Get_ZMin  ());
		pParameters->Get_Parameter("ZMAX" )->Set_Value(pParameter->asGrid()->Get_ZMax  ());
		pParameters->Get_Parameter("ZSTEP")->Set_Value(zStep);

		pParameters->Set_Enabled("ZMAX", zStep > 0.0);
	}

	return( 0 );
}

//---------------------------------------------------------
int CGrid_To_Contour::On_Parameters_Enable(CSG_Parameters *pParameters, CSG_Parameter *pParameter)
{
	if( !SG_STR_CMP(pParameter->Get_Identifier(), "ZSTEP") )
	{
		pParameters->Set_Enabled("ZMAX", pParameter->asDouble() > 0.0);
	}

	return( 0 );
}


///////////////////////////////////////////////////////////
//														 //
//														 //
//														 //
///////////////////////////////////////////////////////////

//---------------------------------------------------------
bool CGrid_To_Contour::On_Execute(void)
{
	m_pGrid			= Parameters("GRID"   )->asGrid  ();
	m_pContours		= Parameters("CONTOUR")->asShapes();

	double	zMin	= Parameters("ZMIN"   )->asDouble();
	double	zMax	= Parameters("ZMAX"   )->asDouble();
	double	zStep	= Parameters("ZSTEP"  )->asDouble();

	//-----------------------------------------------------
	if( zStep <= 0 )	// just one contour value (zMin)
	{
		zStep	= 1;
		zMax	= zMin;
	}
	else if( zMin < m_pGrid->Get_ZMin() )
	{
		zMin	+= zStep * (int)((m_pGrid->Get_ZMin() - zMin) / zStep);
	}

	if( zMax > m_pGrid->Get_ZMax() )
	{
		zMax	= m_pGrid->Get_ZMax();
	}

	//-----------------------------------------------------
	m_pContours->Create(SHAPE_TYPE_Line, m_pGrid->Get_Name(), NULL,
		Parameters("VERTEX")->asInt() == 0 ? SG_VERTEX_TYPE_XY : SG_VERTEX_TYPE_XYZ
	);

	m_pContours->Add_Field("ID", SG_DATATYPE_Int);
	m_pContours->Add_Field(CSG_String::Format(SG_T("%s"),m_pGrid->Get_Name()).BeforeFirst(SG_Char('.')), SG_DATATYPE_Double);

	//-----------------------------------------------------
	m_Rows.Create(SG_DATATYPE_Char, Get_NX() + 1, Get_NY() + 1);
	m_Cols.Create(SG_DATATYPE_Char, Get_NX() + 1, Get_NY() + 1);

	for(double z=zMin; z<=zMax && Set_Progress(z - zMin, zMax - zMin); z+=zStep)
	{
		if( z >= m_pGrid->Get_ZMin() && z <= m_pGrid->Get_ZMax() )
		{
			Process_Set_Text(CSG_String::Format("%s: %s", _TL("Contour"), SG_Get_String(z, -2).c_str()));

			Get_Contour(z);
		}
	}

	m_Rows.Destroy();
	m_Cols.Destroy();

	//-----------------------------------------------------
	return( m_pContours->Get_Count() > 0 );
}


///////////////////////////////////////////////////////////
//														 //
//														 //
//														 //
///////////////////////////////////////////////////////////

//---------------------------------------------------------
#define IS_EDGE(x, y)	((!m_pGrid->is_InGrid(x, y) || m_pGrid->asDouble(x, y) < z) ? 1.0 : 0.0)

//---------------------------------------------------------
bool CGrid_To_Contour::Get_Contour(double z)
{
	int		y;

	//-----------------------------------------------------
	#pragma omp parallel for private(y)
	for(y=0; y<Get_NY()-1; y++)	// Find Border Cells
	{
		for(int x=0; x<Get_NX()-1; x++)
		{
			if( !m_pGrid->is_NoData(x, y) )
			{
				if( m_pGrid->asDouble(x, y) >= z )
				{
					m_Rows.Set_Value(x, y, !m_pGrid->is_NoData(x + 1, y    ) && m_pGrid->asDouble(x + 1, y    ) <  z ? 1 : 0);
					m_Cols.Set_Value(x, y, !m_pGrid->is_NoData(x    , y + 1) && m_pGrid->asDouble(x    , y + 1) <  z ? 1 : 0);
				}
				else
				{
					m_Rows.Set_Value(x, y, !m_pGrid->is_NoData(x + 1, y    ) && m_pGrid->asDouble(x + 1, y    ) >= z ? 1 : 0);
					m_Cols.Set_Value(x, y, !m_pGrid->is_NoData(x    , y + 1) && m_pGrid->asDouble(x    , y + 1) >= z ? 1 : 0);
				}
			}
		}
 	}

	/*/-----------------------------------------------------
	#pragma omp parallel for private(y)
	for(y=0; y<Get_NY(); y++)	// mark edges
	{
		for(int x=0; x<Get_NX(); x++)
		{
			if( !m_pGrid->is_NoData(x, y) && m_pGrid->asDouble(x, y) >= z )
			{
				m_Rows.Set_Value(x    , y    , IS_EDGE(x - 1, y    ));
				m_Rows.Set_Value(x + 1, y    , IS_EDGE(x + 1, y    ));

				m_Cols.Set_Value(x    , y    , IS_EDGE(x    , y - 1));
				m_Cols.Set_Value(x    , y + 1, IS_EDGE(x    , y + 1));
			}
		}
 	}/**/

	//-----------------------------------------------------
	for(y=0; y<Get_NY()-1; y++)	// Interpolation + Delineation
	{
		for(int x=0; x<Get_NX()-1; x++)
		{
			if( m_Rows(x, y) )
			{
				for(int i=0; i<2; i++)
				{
					Start(x, y, z, true);
				}

				m_Rows.Set_Value(x, y, 0.0);
			}

			if( m_Cols(x, y) )
			{
				for(int i=0; i<2; i++)
				{
					Start(x, y, z, false);
				}

				m_Cols.Set_Value(x, y, 0.0);
			}
		}
	}

	//-----------------------------------------------------
	return( true );
}

//---------------------------------------------------------
bool CGrid_To_Contour::Start(int x, int y, double z, bool bRow)
{
	CSG_Shape	*pContour	= m_pContours->Add_Shape();

	pContour->Set_Value(0, m_pContours->Get_Count());
	pContour->Set_Value(1, z);

	//-----------------------------------------------------
	bool	bContinue;

	int		zx	= bRow ? x + 1 : x;
	int		zy	= bRow ? y : y + 1, Dir	= 0;

	//-----------------------------------------------------
	do
	{
		double	d	= m_pGrid->asDouble(x, y);	d	= (d - z) / (d - m_pGrid->asDouble(zx, zy));

		pContour->Add_Point(
			m_pGrid->Get_XMin() + Get_Cellsize() * (x + d * (zx - x)),
			m_pGrid->Get_YMin() + Get_Cellsize() * (y + d * (zy - y))
		);

		if( pContour->Get_Vertex_Type() != SG_VERTEX_TYPE_XY )
		{
			pContour->Set_Z(z, pContour->Get_Point_Count() - 1);
		}

		//-------------------------------------------------
		bContinue	= Find_Next(Dir, x, y, bRow) || Find_Next(Dir, x, y, bRow);

		Dir		= (Dir + 5) % 8;

		//-------------------------------------------------
		if( bRow )
		{
			m_Rows.Set_Value(x, y, 0.0);
			zx	= x + 1;
			zy	= y;
		}
		else
		{
			m_Cols.Set_Value(x, y, 0.0);
			zx	= x;
			zy	= y + 1;
		}
	}
	while( bContinue );

	//-----------------------------------------------------
	return( pContour->Get_Point_Count(0) > 1 );
}

//---------------------------------------------------------
inline bool CGrid_To_Contour::Find_Next(int &Dir, int &x, int &y, bool &bRow)
{
	if( bRow )
	{
		switch( Dir )
		{
		case  0: if( m_Rows(x    , y + 1) ) { Dir = 0;                    y++; return( true ); }	// Norden
		case  1: if( m_Cols(x + 1, y    ) ) { Dir = 1; bRow = false; x++;      return( true ); }	// Nord-Ost
		case  2:	// Osten ist nicht...
		case  3: if( y - 1 >= 0
				 &&  m_Cols(x + 1, y - 1) ) { Dir = 3; bRow = false; x++; y--; return( true ); }	// Sued-Ost
		case  4: if( y - 1 >= 0
				 &&  m_Rows(x    , y - 1) ) { Dir = 4;      y--;               return( true ); }	// Sueden
		case  5: if( y - 1 >= 0
				 &&  m_Cols(x    , y - 1) ) { Dir = 5; bRow = false;      y--; return( true ); }	// Sued-West
		case  6:	// Westen ist nicht...
		case  7: if( m_Cols(x    , y    ) ) { Dir = 7; bRow = false;           return( true ); }	// Nord-West
		default:
			Dir = 0;
		}
	}
	else
	{
		switch( Dir )
		{
		case  0:	// Norden ist nicht...
		case  1: if( m_Rows(x    , y + 1) ) { Dir = 1; bRow =  true;      y++; return( true ); }	// Nord-Ost
		case  2: if( m_Cols(x + 1, y    ) ) { Dir = 2;               x++;      return( true ); }	// Osten
		case  3: if( m_Rows(x    , y    ) ) { Dir = 3; bRow =  true;           return( true ); }	// Sued-Ost
		case  4:	// Sueden ist nicht...
		case  5: if( x - 1 >= 0
				 &&  m_Rows(x - 1, y    ) ) { Dir = 5; bRow =  true; x--;      return( true ); }	// Sued-West
		case  6: if( x - 1 >= 0
				 &&  m_Cols(x - 1, y    ) ) { Dir = 6; x--;                    return( true ); }	// Westen
		case  7: if( x - 1 >= 0
				 &&  m_Rows(x - 1, y + 1) ) { Dir = 7; bRow =  true; x--; y++; return( true ); }	// Nord-West
		default:
			Dir = 0;
		}
	}

	return( false );
}


///////////////////////////////////////////////////////////
//														 //
//														 //
//														 //
///////////////////////////////////////////////////////////

//---------------------------------------------------------