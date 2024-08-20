void async function() {

  const rows = await Deno.readTextFile('./affinities.tsv')
    .then(async (merged) => {
      return await Promise.all(merged
        .split('\n')
        .map(async (line) => {
          try {
            const [name, affinity] = line.split('\t')
            const filename = name.replace('model_0', 'summary_confidences_0.json')
            const {
              chain_iptm,
              chain_pair_iptm,
              chain_pair_pae_min,
              chain_ptm,
              fraction_disordered,
              has_clash,
              iptm,
              num_recycles,
              ptm,
              ranking_score
            } = await Deno.readTextFile(`./artifacts/${filename}`)
              .then(JSON.parse)
            return [
              name,
              affinity,
              chain_iptm.join(),
              chain_pair_iptm.join(),
              chain_pair_pae_min.join(),
              chain_ptm.join(),
              fraction_disordered,
              has_clash,
              iptm,
              num_recycles,
              ptm,
              ranking_score
            ].join('\t')
          } catch (error) {
            console.error(error)
            console.log(line)
          }
        }))
    })

  const columns = [[
    'name',
    'affinity',
    'chain_iptm',
    'chain_pair_iptm',
    'chain_pair_pae_min',
    'chain_ptm',
    'fraction_disordered',
    'has_clash',
    'iptm',
    'num_recycles',
    'ptm',
    'ranking_score'
  ].join('\t')]

  await Deno.writeTextFile('./affinities-merged.tsv', columns.concat(rows).join('\n'))

  console.log('Merged affinities written to affinities-merged.tsv')
}();