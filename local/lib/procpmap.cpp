#include <stdio.h>
#include <string.h>
#include <string>
#include <algorithm>
#include <map>
#include <vector>
using namespace std;

typedef std::map<std::string, int> TStrIntMap;
typedef std::pair<std::string, int> TStrIntPair;
typedef std::vector<TStrIntPair> TStrIntVect;

// 0123456789012345678921234
// 00008000      12K r-xp  /qt/MainPicker
// 00013000    2856K rw-p  [heap]
// 40031000       4K rw-p    [ anon ]

bool mysort (const TStrIntPair &a, const TStrIntPair &b) { return (a.second < b.second); }

bool myrevsort (const TStrIntPair &a, const TStrIntPair &b) { return (a.second > b.second); }

void show (TStrIntMap m) {
    // To sort the map, copy into a vector of pairs because maps don't have
    // random access iterators
    TStrIntVect v;
    TStrIntMap::iterator pm;
    for (pm = m.begin(); pm != m.end(); ++pm)
	v.push_back (*pm);

    sort (v.begin(), v.end(), myrevsort);

    // Print
    TStrIntVect::iterator pv;
    for (pv = v.begin(); pv != v.end(); ++pv)
    {
	std::string k = pv->first;
	int v = pv->second;
	printf ("%s=%d ", k.c_str(), v);
    }
}

int main(int argc, char *argv[])
{
    TStrIntMap m;
    int total=0;

    char buf[1024];
    while (fgets (buf, 1024, stdin))
    {
	int size;
	if (strstr (buf, "no such process"))
	    continue;
	sscanf (buf+9, "%d", &size);
	char *user = buf + 18;
	int len = strlen (user);
	if (len > 0 && user[len-1]=='\n') user[len-1]=0;
	// printf ("%6d %s\n", size, user);
	m[user] += size;
    }

    if (argc == 1) {
       // No cmd line args, Original functionality

       // To sort the map, copy into a vector of pairs because maps don't have
       // random access iterators
       TStrIntVect v;
       TStrIntMap::iterator pm;
       for (pm = m.begin(); pm != m.end(); ++pm)
	   v.push_back (*pm);

       sort (v.begin(), v.end(), mysort);

       // Print
       TStrIntVect::iterator pv;
       for (pv = v.begin(); pv != v.end(); ++pv)
       {
	   std::string k = pv->first;
	   int v = pv->second;
	   printf ("%6d %s\n", v, k.c_str());
	   total += v;
       }
       printf ("%6d %s\n", total, "TOTAL");
    }
    else
    {
	// Special boil-it-down mode
	TStrIntMap m2;

	TStrIntMap::iterator pm;
	for (pm = m.begin(); pm != m.end(); ++pm) {
	    std::string f = pm->first;
	    int size = pm->second;
	   
	    std::string mode = f.substr (0,4);
	    std::string user = f.substr (6);

	    // printf ("%6d '%s' '%s'\n", size, mode.c_str(), user.c_str());
	    
	    // Ignore write-only shared mappings
	    if (mode.find ("-w-s") != std::string::npos)
		continue;

	    total += size;

	    // Handle /dev mappings
	    int pos = user.find ("/dev/");
	    if (pos != std::string::npos) { // devs
		std::string dev = user.substr (pos+5);
		if (dev.find ("mali") == std::string::npos)
		    user="dev/other";
		m2[user] += size;
		continue;
	    }

	    // Handle Code mappings (executables)
	    pos = mode.find ("x");
	    if (pos != std::string::npos) { // code
		std::string k = "other";
		if (user.find ("[vectors") != std::string::npos) 
		    k = "vectors";
		if (user.find ("/lib/") != std::string::npos) 
		    k = "lib";
		if (user.find ("/Brio/") != std::string::npos) 
		    k = "lib";
		m2[k] += size;
		continue;
	    }

	    // Handle RAM mappings (read/write)
	    if (mode.find ("rw") != std::string::npos) { // ram
		pos = user.find ("[");
		// Change "stack:..." to just "stack"
		int pos2 = user.find (":");
		if (pos2 == std::string::npos)
		    pos2 = user.find ("]");
		// Prune annoying white space around " anon "
		//   (whew, this is sloppy!  So many potential bugs here...)
		if (pos != std::string::npos) {
		    if (user.at(pos+1) == ' ')
			pos++;
		    if (user.at(pos2-1) == ' ')
			pos2--;
		    std::string k = user.substr(pos+1, pos2-pos-1);
		    m2[k] += size;
		    continue;
		}
	    }
	    // If all else fails, tally it up
	    m2["other"] += size;
	}
	printf ("total=%d ", total);
	show (m2);
	printf ("\n");
    }
}
