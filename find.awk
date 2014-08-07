BEGIN {
	l = 1;
	qseqid=1;
	sseqid=2;
	pident=3;
	len=4;
	mismatch=5;
	gapopen=6;
	qstart=7;
	qend=8;
	sstart=9;
	send=10;
	evalue=11;
	bitscore=12;

	slop=10;	# how many bases to allow either overlap or gap in subject sequence
	id;
}
{
	for (i = 1; i <= NF; ++i)
		data[l, i] = $i;
	++l;
}
END {
	curq = "";
	curs = "";
	lastqend = -1;
	lastsend = -1;
	for (i = 1; i < l; ++i) {
		if (curq != data[i, qseqid]) {
			curq = data[i, qseqid];
			curs = data[i, sseqid];
		} else {
			if (curs != data[i, sseqid]) {
				curs = data[i, sseqid];
			} else {
				if (abs(data[i, sstart] - lastsend) < slop) {
					if (abs(data[i, qstart] - lastqend) > slop) {
						print_record(id, i - 1);
						print_record(id, i);
						++id;
					}
				}
			}
		}
		lastqend = data[i, qend];
		lastsend = data[i, send];
	}
}
function abs(expr) {
	if (expr < 0)
		expr *= -1;
	return expr;
}
function print_record(instance, idx) {
	printf("%d\t%s\t%s\t%d\t%d\t%d\t%d\n", instance, \
		data[idx, qseqid], data[idx, sseqid], \
		data[idx, qstart], data[idx, qend], data[idx, sstart], data[idx, send]);
#	printf("%d\t%s\t%s\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%f\t%d\n", instance, \
#		data[idx, qseqid], data[idx, sseqid], data[idx, pident], data[idx, len], data[idx, mismatch], data[idx, gapopen], \
#		data[idx, qstart], data[idx, qend], data[idx, sstart], data[idx, send], data[idx, evalue], data[idx, bitscore]);
}
