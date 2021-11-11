﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПолучениеНормативноСправочнойИнформацииДляКС

Функция ПолучитьМРОТ(ДатаОтчета) Экспорт
	
	Если НЕ ТипЗнч(ДатаОтчета) = Тип("Дата") Тогда
		Возврат Неопределено;
	КонецЕсли; 
	
	Если ДатаОтчета > '20210101' Тогда
		Возврат Неопределено
	ИначеЕсли ДатаОтчета > '20200101' Тогда
		Возврат 12130;
	ИначеЕсли ДатаОтчета > '20190101' Тогда
		Возврат 11280;
	ИначеЕсли ДатаОтчета > '20180501' Тогда
		Возврат 11163;
	ИначеЕсли ДатаОтчета > '20180101' Тогда
		Возврат 9489;
	ИначеЕсли ДатаОтчета > '20170101' Тогда
		Возврат 7800;
	Иначе
		Возврат Неопределено;
	КонецЕсли; 
	

КонецФункции // ПолучитьМРОТ()

Функция ПолучитьСреднеотраслевуюЗарплату(Организация, Знач КодРегиона, Знач КодОКВЭД) Экспорт
	
	Результат = Новый Структура("КодРегиона, КодОКВЭД, СредняяЗарплата");
	
	Если Не ЗначениеЗаполнено(КодРегиона) Тогда
		Возврат Результат;
	КонецЕсли; 
	
	Результат.Вставить("КодРегиона", КодРегиона);
	
	Если НЕ ЗначениеЗаполнено(КодОКВЭД) Тогда
		КодОКВЭД = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Организация, "КодОКВЭД2").КодОКВЭД2;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(КодОКВЭД) Тогда
		Возврат Результат;
	КонецЕсли; 
	
	Результат.Вставить("КодОКВЭД", КодОКВЭД);
	
	МакетСреднейЗарплаты = 
		Обработки.РегламентированнаяОтчетностьСоотношенияПоказателей.ПолучитьМакет("СредняяЗарплата2017");
	ТаблицаДанных = ОбщегоНазначения.ЗначениеИзСтрокиXML(МакетСреднейЗарплаты.ПолучитьТекст());
	ТаблицаДанных.Индексы.Добавить("Регион,КодОКВЭД");
	
	СредняяЗарплата = 0;
	Отбор = Новый Структура;
	Отбор.Вставить("Регион", КодРегиона);
	Отбор.Вставить("КодОКВЭД");
	ВозможныеКодыОКВЭД = ИерархияКодовОКВЭД(КодОКВЭД);
	Для каждого ВозможныйКодОКВЭД Из ВозможныеКодыОКВЭД Цикл
		Отбор.КодОКВЭД = ВозможныйКодОКВЭД;
		СтрокиДанных = ТаблицаДанных.НайтиСтроки(Отбор);
		Если СтрокиДанных.Количество() > 0 Тогда
			СредняяЗарплата = СтрокиДанных[0].СредняяЗарплата;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если СредняяЗарплата = 0 Тогда
		Возврат Результат;
	КонецЕсли;
	
	Результат.Вставить("СредняяЗарплата", СредняяЗарплата);
	
	Возврат Результат;

КонецФункции // ПолучитьСреднеотраслевуюЗарплату()

Функция ИерархияКодовОКВЭД(КодОКВЭД)
	
	Результат = Новый Массив;
	Если Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СтрЗаменить(КодОКВЭД, ".", "")) Тогда 
		Возврат Результат; // Корректный код может содержать только цифры и точки
	КонецЕсли;
	ДлинаКода = СтрДлина(КодОКВЭД); 
	Для Поз = 0 По ДлинаКода Цикл
		ЧастьКода = Лев(КодОКВЭД, ДлинаКода - Поз);
		Если СтрЗаканчиваетсяНа(ЧастьКода, ".") Тогда 
			Продолжить; // На точку код оканчиваться не может
		КонецЕсли;
		Результат.Добавить(ЧастьКода);
		Если ДлинаКода - Поз <= 2 Тогда 
			Прервать; // Кодов из 1 символа не бывает
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

Функция ДанныеПроизводственногоКалендаря(Год, Календарь = Неопределено, МассивИсключений = Неопределено) Экспорт
	
	Если НЕ ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КалендарныеГрафики") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если Календарь = Неопределено Тогда
		ИмяСправочника = "ПроизводственныеКалендари";
		Календарь = Справочники[ИмяСправочника].НайтиПоКоду("РФ");
		Если Календарь.Пустая() Тогда 
			Возврат Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Если МассивИсключений = Неопределено Тогда
		МассивИсключений = Новый Массив;
		ИмяПеречисления = "ВидыДнейПроизводственногоКалендаря";
		МассивИсключений.Добавить(Перечисления[ИмяПеречисления].Рабочий);
		МассивИсключений.Добавить(Перечисления[ИмяПеречисления].Предпраздничный);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Календарь"	, Календарь);
	Запрос.УстановитьПараметр("Год"			, Год);
	Запрос.УстановитьПараметр("Исключения"	, МассивИсключений);
	Запрос.Текст =
	
	"ВЫБРАТЬ
	|	Данные.Дата КАК Дата
	|ИЗ
	|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК Данные
	|ГДЕ
	|	Данные.ПроизводственныйКалендарь = &Календарь
	|	И Данные.Год = &Год
	|	И НЕ Данные.ВидДня В (&Исключения)";
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Результат.Выгрузить();
	
КонецФункции

#КонецОбласти

#КонецЕсли
