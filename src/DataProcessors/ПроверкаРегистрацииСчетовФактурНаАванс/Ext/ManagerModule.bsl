﻿
Функция ПроверитьРегистрациюСчетовФактурНаАванс(Интерактивно = Ложь) Экспорт
	
	Если ТекущаяДатаСеанса() >= '20190426' Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Проверяем по доступу
	Если НЕ ПравоДоступа("Просмотр", Метаданные.Обработки.ПроверкаРегистрацииСчетовФактурНаАванс) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Проверяем только в главном узле
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Проверяем только если есть прво просмотра документа "Счет-фактура выданный"
	Если НЕ ПравоДоступа("Просмотр", Метаданные.Документы.СчетФактураВыданный) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если НЕ Интерактивно Тогда
		НеПроверятьПриНачалеРаботы = ХранилищеОбщихНастроек.Загрузить("ПроверкаРегистрацииСчетовФактурНаАванс", "НеПроверятьПриНачалеРаботы");
		Если НеПроверятьПриНачалеРаботы = Истина Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	// Проверяем только если есть плательщики НДС
	Если НЕ ПолучитьФункциональнуюОпцию("ПлательщикНДС") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Проверяем только если есть хоть один счет-фактура
	Если НЕ ЕстьСчетФактура() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;

КонецФункции

Функция ЕстьСчетФактура()
	
	МассивОрганизаций = ОбщегоНазначенияБПВызовСервераПовтИсп.ВсеОрганизацииДанныеКоторыхДоступныПоRLS(Ложь);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачПериода", '20181001000000');
	Запрос.УстановитьПараметр("КонПериода", '20181001235959');
	Запрос.УстановитьПараметр("МассивОрганизаций",МассивОрганизаций);
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	НДСЗаписиКнигиПродаж.Регистратор КАК Документ
	|ИЗ
	|	РегистрНакопления.НДСЗаписиКнигиПродаж КАК НДСЗаписиКнигиПродаж
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СчетФактураВыданный КАК СчетФактураВыданный
	|		ПО НДСЗаписиКнигиПродаж.Регистратор = СчетФактураВыданный.Ссылка
	|ГДЕ
	|	НДСЗаписиКнигиПродаж.Период МЕЖДУ &НачПериода И &КонПериода
	|	И НДСЗаписиКнигиПродаж.ВидЦенности = ЗНАЧЕНИЕ(Перечисление.ВидыЦенностей.АвансыПолученные)
	|	И НДСЗаписиКнигиПродаж.Организация В(&МассивОрганизаций)
	|	И НДСЗаписиКнигиПродаж.ЗаписьДополнительногоЛиста
	|	И НДСЗаписиКнигиПродаж.КорректируемыйПериод < &НачПериода
	|	И НЕ СчетФактураВыданный.Выставлен
	|	И НЕ СчетФактураВыданный.РучнаяКорректировка";
	
	УстановитьПривилегированныйРежим(Истина);
	Если Запрос.Выполнить().Пустой() Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции
