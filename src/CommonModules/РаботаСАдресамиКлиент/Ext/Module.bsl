﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Преобразует введенные английские буквы к русской раскладке при подборе адреса
//
Процедура ПреобразоватьВводАдреса(Текст) Экспорт
	РусскиеКлавиши = "ЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЁ";
	АнглийскиеКлавиши = "QWERTYUIOP[]ASDFGHJKL;'ZXCVBNM,`";
	Текст = ВРег(Текст);
	Для Позиция = 0 По СтрДлина(Текст) Цикл
		Символ = Сред(Текст, Позиция, 1);
		ПозицияСимвола = СтрНайти(АнглийскиеКлавиши, Символ);
		Если ПозицияСимвола > 0 Тогда
			Текст = СтрЗаменить(Текст, Символ, Сред(РусскиеКлавиши, ПозицияСимвола, 1));
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПоказатьКлассификатор(ПараметрыОткрытия, ВладелецФормы, РежимОткрытияОкна = Неопределено) Экспорт
	
	ОткрытьФорму("Справочник.СтраныМира.Форма.Классификатор", ПараметрыОткрытия, ВладелецФормы,,,,, РежимОткрытияОкна);
	
КонецПроцедуры

#КонецОбласти



