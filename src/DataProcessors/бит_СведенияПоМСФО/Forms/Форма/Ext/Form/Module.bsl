﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.ФормаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);

	МетаданныеОбъекта = Метаданные.Обработки.бит_СведенияПоМСФО;
	
	// Вызов механизма лицензирования
	
	
	Параметры.Свойство("ТекущийОбъект", Объект.ТекущийОбъект);
	Параметры.Свойство("ДатаСведений" , Объект.ДатаСведений);
	
	Если НЕ ЗначениеЗаполнено(Объект.ТекущийОбъект) Тогда
		бит_ОбщегоНазначенияКлиентСервер.СообщитьОбОтказеОткрытияОбработкиСамостоятельно(МетаданныеОбъекта.Синоним, Отказ); 
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;	
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.ДатаСведений) Тогда
		Объект.ДатаСведений = ТекущаяДатаСеанса();
	КонецЕсли;
	
	ОбновитьСведенияМСФО();
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаСведенийПриИзменении(Элемент)
	
	ОбновитьСведенияМСФО();
	
	бит_РаботаСДиалогамиКлиент.РазвернутьДеревоПолностью(Элементы.ДеревоПараметров,ДеревоПараметров.ПолучитьЭлементы(),Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Управляет видимостью\доступностью элементов формы.
// 
&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	Если ТипЗнч(Объект.ТекущийОбъект) = Тип("СправочникСсылка.ОсновныеСредства") Тогда
		ПредставлениеОбъекта = "Основное средство";
	ИначеЕсли ТипЗнч(Объект.ТекущийОбъект) = Тип("СправочникСсылка.НематериальныеАктивы") Тогда
		ПредставлениеОбъекта = "НМА";
	Иначе
		ПредставлениеОбъекта = "Текущий объект";
	КонецЕсли;
	
	Элементы.ТекущийОбъект.Заголовок = ПредставлениеОбъекта;
	
КонецПроцедуры

// Получает сведения для ОС/НМА по МСФО.
// 
&НаСервере
Процедура ОбновитьСведенияМСФО()
	
	Если ТипЗнч(Объект.ТекущийОбъект) = Тип("СправочникСсылка.ОсновныеСредства") Тогда
		ВидВНА = "ОС";
	ИначеЕсли ТипЗнч(Объект.ТекущийОбъект) = Тип("СправочникСсылка.НематериальныеАктивы") Тогда
		ВидВНА = "НМА";
	Иначе
		Возврат;
	КонецЕсли;
	
	дзДеревоПараметров = ДанныеФормыВЗначение(ДеревоПараметров, Тип("ДеревоЗначений"));
	
	дзДеревоПараметров = бит_му_ВНА.ПолучитьДеревоПараметровВНА(Объект.ДатаСведений, Объект.ТекущийОбъект, ВидВНА);
	
	ЗначениеВДанныеФормы(дзДеревоПараметров, ДеревоПараметров);
	
КонецПроцедуры

#КонецОбласти

