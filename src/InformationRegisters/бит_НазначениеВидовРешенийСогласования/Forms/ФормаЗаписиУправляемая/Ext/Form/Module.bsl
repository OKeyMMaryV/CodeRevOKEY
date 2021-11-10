﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	МетаданныеОбъекта = Метаданные.РегистрыСведений.бит_НазначениеВидовРешенийСогласования;
    
    бит_РаботаСДиалогамиСервер.ФормаЗаписиРегистраПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтотОбъект);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	фДоступныеОбъектыСистемы = бит_Визирование.ВизируемыеОбъектыСистемы();
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Ссылка", фДоступныеОбъектыСистемы);
	бит_ОбщегоНазначенияКлиентСервер.УстановитьПараметрыВыбораЭлемента(Элементы.ОбъектСистемы, СтруктураПараметров);
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбъектСистемыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СписокВидовОбъектов = Новый СписокЗначений;
	СписокВидовОбъектов.Добавить(ПредопределенноеЗначение("Перечисление.бит_ВидыОбъектовСистемы.Документ"));
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВидыОбъектов"           , СписокВидовОбъектов);
	ПараметрыФормы.Вставить("ТекущийОбъектСистемы"   , Запись.ОбъектСистемы);
	ПараметрыФормы.Вставить("ДоступныеОбъектыСистемы", фДоступныеОбъектыСистемы);
	ОткрытьФорму("ОбщаяФорма.бит_ФормаВыбораОбъектовСистемыУправляемая", ПараметрыФормы,Элемент);
	
КонецПроцедуры

#КонецОбласти
