package team.abc.ssm.modules.doc.dao;

import team.abc.ssm.modules.doc.entity.Journal;

import java.util.List;

public interface JournalDao {

    List<Journal> listAll();

    List<Journal> list(Journal journal);

    int listCount(Journal journal);

    int deleteByIds(List<Journal> list);

    int deleteAll();

    void updateJournal(Journal journal);
}
