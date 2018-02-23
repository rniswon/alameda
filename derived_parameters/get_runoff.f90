!  get_runoff.f90 
!
!  FUNCTIONS:
!  get_runoff - Entry point of console application.
!

!****************************************************************************
!
!  PROGRAM: get_runoff
!
!  PURPOSE:  Entry point for the console application.
!
!****************************************************************************

    program get_runoff

    implicit none

    ! Variables
    CHARACTER(LEN=80) line 
    CHARACTER(LEN=40) line2
    INTEGER LLOC,ISTART,ISTOP,I,IOUT,IN,iout2,numvals,iloc,intchk,Io_stat,L,isave
    INTEGER idum, j
    real fdum
    REAL r, totrunoff,runofftemp
!    REAL,SAVE,DIMENSION(:),POINTER :: runoff
    logical :: found
    in = 10
    iout = 11
    iout2 = 12
    Io_stat = 0
    open(in,file='SFR_streams.out')
    open(iout,file='runoff.out')
    open(iout2,file='info.out')
    found = .false.
    i=0
    totrunoff = 0.0
    runofftemp = 0.0
! determine how many lines are in file for allocating array
    do
      read(in,*,IOSTAT=Io_stat) line
      LLOC=1
      CALL URWORD(LINE,LLOC,ISTART,ISTOP,1,I,R,IOUT,IN)
      select case (LINE(ISTART:ISTOP))
      case('STREAM')
            found = .true.
            write(iout2,*)'found stream listing'
            write(*,*)'found stream listing'
      case default
            if( Io_stat < 0 ) then
              write(iout2,*)'end of file reached, lines of data = ',i
              exit
            end if
      end select
      i = i + 1
    end do
    rewind(10)
!    allocate (runoff(i))
    read(in,*) line       !skip header lines
    LLOC=1
    CALL URWORD(LINE,LLOC,ISTART,ISTOP,1,I,R,IOUT,IN)
    do i = 1, 2
      read(in,*) line
    end do
     i = 0
     do
       read(in,*,IOSTAT=Io_stat)idum,idum,idum,idum,idum,fdum,fdum,fdum,runofftemp
       if (Io_stat < 0 .and. .not. found) then
         write(iout2,*)'Cannot find runoff values in file. Stopping'
         write(*,*)'Cannot find runoff values in file. Stopping'
         exit
       elseif(Io_stat < 0 .and. found) then
         write(iout2,*)'Total runoff values read = ',i
         write(*,*)'Total runoff values read = ',i
         exit
       else
         found = .true.
         if ( i==0 ) backspace(in)
         i = i + 1
         totrunoff = totrunoff + runofftemp
       end if
     end do
     if(found) then
        write(iout,*) totrunoff
     end if  
    end program get_runoff

