! Data Assimilation Research Testbed -- DART
! Copyright 2004-2007, Data Assimilation Research Section
! University Corporation for Atmospheric Research
! Licensed under the GPL -- www.gpl.org/licenses/gpl.html
 
program id_set_def_stdin

! <next few lines under version control, do not edit>
! $URL$
! $Id$
! $Revision$
! $Date$

use  location_mod, only : location_type
use utilities_mod, only : get_unit
use     model_mod, only : static_init_model, get_model_size, &
                          TYPE_PS, get_state_meta_data

implicit none

! version controlled file description for error handling, do not edit
character(len=128), parameter :: &
   source   = "$URL$", &
   revision = "$Revision$", &
   revdate  = "$Date$"

integer :: i, model_size, var_type, iunit
type(location_type) :: location

! Write to file
iunit  = get_unit()
open(unit = iunit, file = 'id_set_def_stdin.out')

! Get the model size
call static_init_model()
model_size = get_model_size()

! Set the number of state variables, all observed
write(iunit, *) model_size

! No values or qc
write(iunit, *) 0
write(iunit, *) 0

! Loop through all the state variables, set the obs variance accordingly
do i = 1, model_size
   ! There are more obs
   write(iunit, *) 0

   ! Identity obs
   write(iunit, *) -1 * i

   ! Time is 0 days 0 seconds for create obs sequence
   write(iunit, *) 0, 0

   call get_state_meta_data(i, location, var_type)

   ! Output the appropriate observational error variance
   if(var_type == TYPE_PS) then
   write(iunit, *)  10000.0
   else
      write(iunit, *) 1.0
   endif

end do

! Output the default set_def.out file name
write(iunit, *) 'set_def.out'

end program id_set_def_stdin
