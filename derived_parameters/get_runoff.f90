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
    INTEGER idum, j, in2, in3, iseg, max, segnum, k
    real fdum
    REAL r, totrunoff,runofftemp
    REAL,SAVE,DIMENSION(:),POINTER :: runoff, runoffsub, runoffsum
    INTEGER,SAVE,DIMENSION(:),POINTER :: subbasin
    INTEGER,SAVE,DIMENSION(:,:),POINTER :: subbasin_trib
    INTEGER,SAVE,DIMENSION(:),POINTER :: seg
    logical :: found
    in = 8
    in2 = 9
    in3 = 10
    iout = 11
    iout2 = 12
    Io_stat = 0
    open(in,file='SFR_streams.out')
    open(in2,file='subbasin.txt')
    open(in3,file='subbasin_trib.txt')
    open(iout,file='runoff.out')
    open(iout2,file='info.out')
    found = .false.
    iseg = 0
    totrunoff = 0.0
    runofftemp = 0.0
    max = 1
    subbasin = 0
    seg = 0
! Count number of segments
    do
      read(in2,*,IOSTAT=Io_stat) line 
      if (Io_stat < 0 ) exit
      iseg = iseg + 1
    end do
!    iseg = iseg - 1
    allocate(subbasin(iseg),seg(iseg))
    rewind(in2)
! Read segment subbasin information
    do i = 1, iseg
      read(in2,*,IOSTAT=Io_stat) idum, subbasin(i)
      if ( subbasin(i) > max ) max = subbasin(i)
    end do
    allocate(subbasin_trib(max,max),runoffsub(max),runoffsum(max))
    subbasin_trib = 0.0
    runoffsub = 0.0
    runoffsum = 0.0
    do i = 1, iseg
      read (in3,*,IOSTAT=Io_stat) idum
      backspace(in3)
        read(in3,*,IOSTAT=Io_stat) idum, (subbasin_trib(j,i),j=1,idum)
    end do
        
! determine how many lines are in file for allocating array
      i = 0
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
    rewind(in)
    allocate (runoff(i))
    runoff = 0.0
    do i = 1, 3
      read(in,*) line
    end do
     i = 1
! total runoff by segment
     do
       read(in,*,IOSTAT=Io_stat)idum,idum,idum,segnum,idum,fdum,fdum,fdum,fdum
       runoff(segnum) = runoff(segnum) + fdum
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
         i = i + 1
       end if
     end do
! first total runoff by subbasin, excluding tributary subbasin inflows
     if(found) then
       do i = 1, iseg
         j = subbasin(i)
         runoffsub(j) = runoffsub(j) + runoff(i)
       end do
! add tributary subbasin inflows
       do i = 1, max
         runoffsum(i) = runoffsub(i)
         do j = 1, max
           k = subbasin_trib(j,i)
           if ( k > 0 ) then
             runoffsum(i) = runoffsum(i) + runoffsub(k)
           end if
         end do
       end do
       do i = 1, max
         write(iout,*)i,runoffsum(i)
       end do
     end if  
    end program get_runoff

