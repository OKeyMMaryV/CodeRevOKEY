﻿Функция ПредопределенныеСчетаРасходов() Экспорт
	
	СчетаРасходов = Новый Массив;
	ЭлементыЗатрат.ЗаполнитьПредопределенныеСчетаРасходов(СчетаРасходов);
	Возврат Новый ФиксированныйМассив(СчетаРасходов);
	
КонецФункции

Функция РазрезыУчетаРасходовНаПланеСчетов()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СчетаРасходов", ПредопределенныеСчетаРасходов());
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Хозрасчетный.Ссылка КАК Счет
	|ПОМЕСТИТЬ СчетаРасходов
	|ИЗ
	|	ПланСчетов.Хозрасчетный КАК Хозрасчетный
	|ГДЕ
	|	Хозрасчетный.Ссылка В ИЕРАРХИИ(&СчетаРасходов)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Счет
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВидыСубконто.ВидСубконто КАК ВидСубконто
	|ИЗ
	|	ПланСчетов.Хозрасчетный.ВидыСубконто КАК ВидыСубконто
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ СчетаРасходов КАК СчетаРасходов
	|		ПО ВидыСубконто.Ссылка = СчетаРасходов.Счет
	|ГДЕ
	|	ВидыСубконто.ТолькоОбороты
	|	И ВидыСубконто.Суммовой";
	
	РазрезыУчета = Новый Массив;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		РазрезыУчета.Добавить(Выборка.ВидСубконто);
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(РазрезыУчета);
	
КонецФункции

Процедура ДобавитьОписаниеРазрезовУчета(ОписаниеРазрезовУчета, ШаблонОписанияСчетов, ШаблонОписанияВидовСубконто, ШаблонОписанияПараметров, ШаблонОписанияИсключений) Экспорт
	
	// Описание параметров см. в ОбщегоНазначенияБП.ПолучитьСоответствиеСубконтоПараметрамУчета()
	
	ОписаниеСчетов = ШаблонОписанияСчетов.СкопироватьКолонки();
	Для Каждого СчетРасходов Из ПредопределенныеСчетаРасходов() Цикл
		НоваяСтрока = ОписаниеСчетов.Добавить();
		НоваяСтрока.Счет          = СчетРасходов;
		НоваяСтрока.СПодчиненными = Истина;
	КонецЦикла;
	
	Для Каждого ИмяПараметра Из ПараметрыУчета() Цикл
		
		ОписаниеРазрезаУчета = ОписаниеРазрезовУчета.Добавить();
		ОписаниеРазрезаУчета.Счета = ОписаниеСчетов;
	
		ОписаниеРазрезаУчета.Субконто  = ШаблонОписанияВидовСубконто.СкопироватьКолонки();
		НоваяСтрока = ОписаниеРазрезаУчета.Субконто.Добавить();
		НоваяСтрока.Вид            = ВидСубконто(ИмяПараметра);
		НоваяСтрока.Суммовой       = Истина;
		НоваяСтрока.ТолькоОбороты  = Истина;
		НоваяСтрока.Количественный = Ложь;
		НоваяСтрока.Валютный       = Ложь;
		НоваяСтрока.Параметр       = ИмяПараметра;
	
		ОписаниеРазрезаУчета.Параметры = ШаблонОписанияПараметров.СкопироватьКолонки();
		НоваяСтрока = ОписаниеРазрезаУчета.Параметры.Добавить();
		НоваяСтрока.Имя        = ИмяПараметра;
		НоваяСтрока.Исключения = ШаблонОписанияИсключений.Скопировать();
		
	КонецЦикла
	
КонецПроцедуры

Процедура ПрочитатьЗначенияПараметровУчета(ПараметрыУчета) Экспорт
	
	РазрезыУчетаРасходов = РазрезыУчетаРасходовНаПланеСчетов();
	
	Для Каждого ИмяПараметра Из ПараметрыУчета() Цикл
		
		ВидСубконто = ВидСубконто(ИмяПараметра);
		
		СубконтоИспользуется = (РазрезыУчетаРасходов.Найти(ВидСубконто) <> Неопределено);
		
		ПараметрыУчета[ИмяПараметра] = СубконтоИспользуется;
		
	КонецЦикла;
	
КонецПроцедуры

Функция РазрезыУчетаРасходов(Период, Организация) Экспорт
	
	РазрезыУчетаРасходов = Новый Массив;
	
	РазрезыУчетаРасходовНаПланеСчетов = РазрезыУчетаРасходовНаПланеСчетов();
	
	Если РазрезыУчетаРасходовНаПланеСчетов.Количество() = 0 Тогда
		Возврат РазрезыУчетаРасходов;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Период",      Период);
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УчетнаяПолитика.УчитыватьРасходыПоЭлементамЗатрат КАК УчитыватьРасходыПоЭлементамЗатрат,
	|	УчетнаяПолитика.УчитыватьРасходыПоСтатьямЗатрат КАК УчитыватьРасходыПоСтатьямЗатрат
	|ИЗ
	|	РегистрСведений.УчетнаяПолитика.СрезПоследних(&Период, Организация = &Организация) КАК УчетнаяПолитика";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Не Выборка.Следующий() Тогда
		Возврат РазрезыУчетаРасходов;
	КонецЕсли;
	
	ИменаПараметров = Новый Массив;
	ИменаПараметров.Добавить("УчитыватьРасходыПоЭлементамЗатрат");
	ИменаПараметров.Добавить("УчитыватьРасходыПоСтатьямЗатрат");
	
	Для Каждого ИмяПараметра Из ИменаПараметров Цикл
		
		Если Не Выборка[ИмяПараметра] Тогда
			Продолжить;
		КонецЕсли;
		
		ВидСубконто = ВидСубконто(ИмяПараметра);
		Если РазрезыУчетаРасходовНаПланеСчетов.Найти(ВидСубконто) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		РазрезыУчетаРасходов.Добавить(ВидСубконто);
		
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(РазрезыУчетаРасходов);
	
КонецФункции

Функция РасходыУчитываютсяПоЭлементамЗатрат(НачалоПериода, КонецПериода, Организация) Экспорт
	
	РазрезыУчетаРасходовНаПланеСчетов = РазрезыУчетаРасходовНаПланеСчетов();
	Если РазрезыУчетаРасходовНаПланеСчетов.Найти(ВидСубконтоЭлементыЗатрат()) = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода",  КонецПериода);
	Запрос.УстановитьПараметр("Организация",   Организация);
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	УчетнаяПолитика.УчитыватьРасходыПоЭлементамЗатрат КАК УчитыватьРасходыПоЭлементамЗатрат
	|ИЗ
	|	РегистрСведений.УчетнаяПолитика.СрезПоследних(&НачалоПериода, Организация = &Организация) КАК УчетнаяПолитика
	|ГДЕ
	|	УчетнаяПолитика.УчитыватьРасходыПоЭлементамЗатрат
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	УчетнаяПолитика.УчитыватьРасходыПоЭлементамЗатрат КАК УчитыватьРасходыПоЭлементамЗатрат
	|ИЗ
	|	РегистрСведений.УчетнаяПолитика КАК УчетнаяПолитика
	|ГДЕ
	|	НЕ УчетнаяПолитика.УчитыватьРасходыПоЭлементамЗатрат
	|	И УчетнаяПолитика.Организация = &Организация
	|	И УчетнаяПолитика.Период МЕЖДУ &НачалоПериода И &КонецПериода";
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Если РезультатЗапроса[0].Пустой() Тогда
		// На начало периода режим выключен
		Возврат Ложь;
	КонецЕсли;
	
	Если Не РезультатЗапроса[1].Пустой() Тогда
		// В течение периода режим выключен
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция ПараметрыУчета() Экспорт
	
	// На каждый параметр в форме НастройкаПараметровУчета должно быть два реквизита типа Булево:
	// 1. С именем параметра, например, "ВестиУчетРасходовПоСтатьямЗатрат"
	// 2. С именем параметра, к которому добавлены слова "ИсходноеЗначение", например "ВестиУчетРасходовПоСтатьямЗатратИсходноеЗначение"
	
	// Эти же имена используются в СоответствиеВидовСубконтоПараметрамУчета()
	
	ПараметрыУчета = Новый Массив;
	ЭлементыЗатрат.ЗаполнитьПараметрыУчета(ПараметрыУчета);
	Возврат Новый ФиксированныйМассив(ПараметрыУчета);
	
КонецФункции

Функция ВидСубконто(ИмяПараметра) Экспорт
	
	// Имена параметров определены в ПараметрыУчета()
	
	ВидСубконто = Неопределено;
	ЭлементыЗатрат.ОпределитьВидСубконтоПоИмениПараметра(ВидСубконто, ИмяПараметра);
	Возврат ВидСубконто;
	
КонецФункции                                                                                                        

Функция ВидСубконтоЭлементыЗатрат() Экспорт
	
	ВидСубконто = Неопределено;
	ЭлементыЗатрат.ОпределитьВидСубконтоЭлементыЗатрат(ВидСубконто);
	Возврат ВидСубконто;
	
КонецФункции