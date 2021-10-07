﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция  СформироватьЗапросПоСотрудникамДляПроверки()
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ТаблицаСотрудники", Сотрудники);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаСотрудники.Сотрудник,
	|	ТаблицаСотрудники.Фамилия,
	|	ТаблицаСотрудники.Имя,
	|	ТаблицаСотрудники.Отчество,
	|	ТаблицаСотрудники.СтраховойНомерПФР,
	|	ТаблицаСотрудники.АдресДляИнформирования,
	|	ТаблицаСотрудники.ДатаЗаполнения,
	|	ТаблицаСотрудники.НомерСтроки
	|ПОМЕСТИТЬ ВТСотрудники
	|ИЗ
	|	&ТаблицаСотрудники КАК ТаблицаСотрудники";
	
	Запрос.Выполнить();
	
	КадровыйУчет.СоздатьВТФизическиеЛицаРаботавшиеВОрганизации(Запрос.МенеджерВременныхТаблиц, Истина, Организация, Дата, Дата);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СотрудникиДокумента.НомерСтроки,
	|	СотрудникиДокумента.Сотрудник КАК Сотрудник,
	|	СотрудникиДокумента.Сотрудник.Наименование КАК СотрудникНаименование,
	|	СотрудникиДокумента.АдресДляИнформирования,
	|	СотрудникиДокумента.СтраховойНомерПФР КАК СтраховойНомерПФР,
	|	СотрудникиДокумента.Фамилия,
	|	СотрудникиДокумента.Имя,
	|	СотрудникиДокумента.Отчество,
	|	СотрудникиДокумента.СтраховойНомерПФР КАК СтраховойНомерПФР1,
	|	ДублиСтрок.НомерСтроки КАК КонфликтующаяСтрока,
	|	ВЫБОР
	|		КОГДА АктуальныеСотрудники.ФизическоеЛицо ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК СотрудникРаботаетВОрганизации
	|ИЗ
	|	ВТСотрудники КАК СотрудникиДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТСотрудники КАК ДублиСтрок
	|		ПО СотрудникиДокумента.Сотрудник = ДублиСтрок.Сотрудник
	|			И СотрудникиДокумента.НомерСтроки > ДублиСтрок.НомерСтроки
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТФизическиеЛицаРаботавшиеВОрганизации КАК АктуальныеСотрудники
	|		ПО СотрудникиДокумента.Сотрудник = АктуальныеСотрудники.ФизическоеЛицо";
	
	Возврат Запрос.Выполнить()
	
КонецФункции

Процедура ПроверитьДанныеДокумента(Отказ) Экспорт 
	
	ПроверяемыеРеквизитыСотрудника = Новый Массив;
	ПроверяемыеРеквизитыСотрудника.Добавить("Сотрудники.Фамилия");
	ПроверяемыеРеквизитыСотрудника.Добавить("Сотрудники.Имя");
	ПроверяемыеРеквизитыСотрудника.Добавить("Сотрудники.СтраховойНомерПФР");
	ПроверяемыеРеквизитыСотрудника.Добавить("Сотрудники.АдресДляИнформирования");
	
	НеПроверяемыеРеквизиты = Новый Массив;
	
	Если Не ПроверитьЗаполнение() Тогда
		Отказ = Истина;
	КонецЕсли;	
	
	ПерсонифицированныйУчет.ПроверитьДанныеОрганизации(ЭтотОбъект, Организация, Отказ);

	НаименованиеОрганизации = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Организация, "Наименование");
	
	ВыборкаСотрудникиДляПроверки = СформироватьЗапросПоСотрудникамДляПроверки().Выбрать();
	
	Пока ВыборкаСотрудникиДляПроверки.Следующий() Цикл
		Если ЗначениеЗаполнено(ВыборкаСотрудникиДляПроверки.Сотрудник) Тогда
			Если Не ВыборкаСотрудникиДляПроверки.СотрудникРаботаетВОрганизации Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Сотрудник %2 не работает в организации %3.'"), ВыборкаСотрудникиДляПроверки.НомерСтроки, ВыборкаСотрудникиДляПроверки.СотрудникНаименование, НаименованиеОрганизации);
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, Ссылка, "Объект.Сотрудники[" + Формат(ВыборкаСотрудникиДляПроверки.НомерСтроки - 1, "ЧН=0; ЧГ=0") + "].Сотрудник",,Отказ);
			КонецЕсли;
			Если ВыборкаСотрудникиДляПроверки.КонфликтующаяСтрока <> Null Тогда
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Информация о сотруднике %2 была введена в документе ранее.'"), ВыборкаСотрудникиДляПроверки.НомерСтроки, ВыборкаСотрудникиДляПроверки.СотрудникНаименование);
				ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, Ссылка, "Объект.Сотрудники[" + Формат(ВыборкаСотрудникиДляПроверки.НомерСтроки - 1, "ЧН=0; ЧГ=0") + "].Сотрудник",,Отказ);
			КонецЕсли;
			
			ФизическиеЛицаЗарплатаКадры.ПроверитьПерсональныеДанныеСотрудника(Ссылка, ВыборкаСотрудникиДляПроверки, ПроверяемыеРеквизитыСотрудника, НеПроверяемыеРеквизиты, Дата, Истина, Отказ); 
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ОкончаниеОтчетногоПериода() Экспорт
	
	Возврат КонецДня(Дата);
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли