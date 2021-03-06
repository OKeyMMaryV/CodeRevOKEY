
&НаСервере
Процедура ПодготовитьФормуНаСервере()

	// Включим предопределенные счета и их субсчета
	// - СчетЗатрат - 25, 26
	СчетаЗатрат = УчетЗатрат.ПредопределенныеСчетаКосвенныхРасходов();
	УсловияОтбораСубсчетов = БухгалтерскийУчет.НовыеУсловияОтбораСубсчетов();
	УсловияОтбораСубсчетов.ИспользоватьВПроводках = Истина;
	СчетаДляОтбора = БухгалтерскийУчет.СформироватьМассивСубсчетовПоОтбору(СчетаЗатрат, УсловияОтбораСубсчетов);
	БухгалтерскийУчетКлиентСервер.ИзменитьПараметрыВыбораСчета(Элементы.СчетЗатрат, СчетаДляОтбора);
	// - СчетПрямыхЗатрат - 20, 23
	УчетПроизводства.ОграничитьВыборСчетамиПрямыхРасходов(Элементы.СчетПрямыхЗатрат);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Форма.Элементы.СписокСтатейЗатрат.Доступность = 
			Форма.Запись.БазаРаспределения = ПредопределенноеЗначение("Перечисление.БазыРаспределенияКосвенныхРасходов.ОтдельныеСтатьиПрямыхЗатрат");
	ДоступностьПолейВыручки = Форма.Запись.БазаРаспределения = ПредопределенноеЗначение("Перечисление.БазыРаспределенияКосвенныхРасходов.Выручка");
	Форма.Элементы.СчетПрямыхЗатрат.Доступность    = ДоступностьПолейВыручки;
	Форма.Элементы.ПодразделениеЗатрат.Доступность = ДоступностьПолейВыручки;

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПодготовитьФормуНаСервере();
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
КонецПроцедуры

&НаКлиенте
Процедура БазаРаспределенияПриИзменении(Элемент)
	
	Если Запись.БазаРаспределения <> ПредопределенноеЗначение("Перечисление.БазыРаспределенияКосвенныхРасходов.ОтдельныеСтатьиПрямыхЗатрат") Тогда
		Запись.СписокСтатейЗатрат = Неопределено;
	КонецЕсли;
	Если Запись.БазаРаспределения <> ПредопределенноеЗначение("Перечисление.БазыРаспределенияКосвенныхРасходов.Выручка") Тогда
		Запись.СчетПрямыхЗатрат = Неопределено;
		Запись.ПодразделениеЗатрат = Неопределено;
	ИначеЕсли Запись.СчетЗатрат = ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.ОбщепроизводственныеРасходы")
		И ЗначениеЗаполнено(Запись.СчетПрямыхЗатрат) Тогда
		Запись.ПодразделениеЗатрат = Запись.Подразделение;	
	КонецЕсли;
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	Если Запись.БазаРаспределения = ПредопределенноеЗначение("Перечисление.БазыРаспределенияКосвенныхРасходов.Выручка")
		И Запись.СчетЗатрат = ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.ОбщепроизводственныеРасходы") 
		И ЗначениеЗаполнено(Запись.СчетПрямыхЗатрат) Тогда
		Запись.ПодразделениеЗатрат = Запись.Подразделение;	
	КонецЕсли;		
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеЗатратПриИзменении(Элемент)
	
	Если Запись.БазаРаспределения = ПредопределенноеЗначение("Перечисление.БазыРаспределенияКосвенныхРасходов.Выручка")
		И Запись.СчетЗатрат = ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.ОбщепроизводственныеРасходы") 
		И ЗначениеЗаполнено(Запись.СчетПрямыхЗатрат) Тогда
		Запись.Подразделение = Запись.ПодразделениеЗатрат;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СчетЗатратПриИзменении(Элемент)
	
	Если Запись.БазаРаспределения = ПредопределенноеЗначение("Перечисление.БазыРаспределенияКосвенныхРасходов.Выручка")
		И Запись.СчетЗатрат = ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.ОбщепроизводственныеРасходы") Тогда
		Если ЗначениеЗаполнено(Запись.Подразделение) Тогда 
			Запись.Подразделение = Запись.ПодразделениеЗатрат;
		ИначеЕсли ЗначениеЗаполнено(Запись.ПодразделениеЗатрат) Тогда
			Запись.ПодразделениеЗатрат = Запись.Подразделение;	
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СчетПрямыхЗатратПриИзменении(Элемент)
	
	Если Запись.БазаРаспределения = ПредопределенноеЗначение("Перечисление.БазыРаспределенияКосвенныхРасходов.Выручка")
		И Запись.СчетЗатрат = ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.ОбщепроизводственныеРасходы") 
		И ЗначениеЗаполнено(Запись.СчетПрямыхЗатрат) Тогда
		Запись.ПодразделениеЗатрат = Запись.Подразделение;	
	КонецЕсли;
	
КонецПроцедуры

