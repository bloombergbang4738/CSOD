#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdarg.h>
#include <string.h>
#include <errno.h>
#include <netdb.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include "skel.h"

char *program_name;

/* error - print a diagnostic and optionally exit */
void error( int status, int err, char *fmt, ... )
{
	va_list ap;

	va_start( ap, fmt );
	fprintf( stderr, "%s: ", program_name );
	vfprintf( stderr, fmt, ap );
	va_end( ap );
	if ( err )
		fprintf( stderr, ": %s (%d)\n", strerror( err ), err );
	if ( status )
		EXIT( status );
}

/* set_address - fill in a sockaddr_in structure */
static void set_address( char *hname, char *sname,
	struct sockaddr_in *sap, char *protocol )
{
	struct servent *sp;
	struct hostent *hp;
	char *endptr;
	short port;

	bzero( sap, sizeof( *sap ) );
	sap->sin_family = AF_INET;
	if ( hname != NULL )
	{
		if ( !inet_aton( hname, &sap->sin_addr ) )
		{
			hp = gethostbyname( hname );
			if ( !hp )
				error( 1, 0, "unknown host: %s\n", hname );
			sap->sin_addr = *( struct in_addr * )hp->h_addr;
		}
	}
	else
		sap->sin_addr.s_addr = htonl( INADDR_ANY );
	port = strtol( sname, &endptr, 0 );
	if ( *endptr == '\0' )
		sap->sin_port = htons( port );
	else
	{
		sp = getservbyname( sname, protocol );
		if ( !sp )
			error( 1, 0, "unknown service: %s\n", sname );
		sap->sin_port = sp->s_port;
	}
}

/* server - place holder for server */
static void server( SOCKET s, struct sockaddr_in *localp )
{
	struct sockaddr_in peer;
	int peerlen;
	char buf[ 1 ];

	for ( ;; )
	{
		peerlen = sizeof( peer );
		if ( recvfrom( s, buf, sizeof( buf ), 0,
			( struct sockaddr * )&peer, &peerlen ) < 0 )
			error( 1, errno, "recvfrom failed" );
		if ( sendto( s, "hello, world\n", 13, 0,
			( struct sockaddr * )&peer, peerlen ) < 0 )
			error( 1, errno, "sendto failed" );
	}
}

/* main - UDP setup */
int main( int argc, char **argv )
{
	struct sockaddr_in local;
	char *hname;
	char *sname;
	SOCKET s;

	INIT();

	if ( argc == 2 )
	{
		hname = NULL;
		sname = argv[ 1 ];
	}
	else
	{
		hname = argv[ 1 ];
		sname = argv[ 2 ];
	}

	set_address( hname, sname, &local, "udp" );
	s = socket( AF_INET, SOCK_DGRAM, 0 );
	if ( !isvalidsock( s ) )
		error( 1, errno, "socket call failed" );

	if ( bind( s, ( struct sockaddr * ) &local,
		 sizeof( local ) ) )
		error( 1, errno, "bind failed" );

	server( s, &local );
	EXIT( 0 );
}
