!  ReformARRAY.f90 
!
!  FUNCTIONS:
!  ReformARRAY      - Entry point of console application.
!

!****************************************************************************
!
!  PROGRAM: ReformARRAY
!
!  PURPOSE:  Entry point for the console application.
!
!****************************************************************************

    program ReformARRAY

    implicit none

    ! Variables
    integer i, j, nx, ny
    real, dimension(999999) :: dARR
    character*128 txt

    ! Body of ReformARRAY
 
    write(*,*) '  Enter NX and NY ' 
    read(*,*) nx, ny 
    write(*,*) '  Enter name of file to reformat ' 
    read(*,*) txt
    open(5,file=txt) 
    read(5,*)(darr(i),i=1,nx*ny)
    close(5)
    open(5,file=txt) 
    do j = 1, ny
      write(5,'(4000E14.7)')(darr(i),i=(j-1)*nx+1 , j*nx)
    enddo 

    close(5)

    end program ReformARRAY

