BEGIN {
	s = 0;
	if (table == "")
		table = "sequences";
	if (create_table == 1)
		printf("DROP TABLE IF EXISTS %s; CREATE TABLE %s ( locus VARCHAR(128) PRIMARY KEY, description VARCHAR(256), sequence LONGTEXT );", table, table);
}

/^>/ {
	++s;
	split($1, a, "|"); 
	split(a[4], b, "."); 
	locus[s] = b[1]; 
	description[s] = $2;
	for (i = 3; i <= NF; ++i)
		description[s] = description[s] " " $i; 
	sequence[s] = "";
}
{
	if (substr($1, 1, 1) != ">")
		sequence[s] = sequence[s] $1;
}
END {
	for (i = 1; i <= s; ++i) { 
		printf("INSERT INTO %s (locus, description, sequence) VALUES (\"%s\", \"%s\", \"%s\");\n", table, locus[i], description[i], sequence[i]);
	}
} 
