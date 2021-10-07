﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "АнализДепонированнойЗарплаты");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Зарегистрированные суммы депонентов и сведения о выплате таких сумм 
		|за указанный год. Формирование отчета за период менее года не предусмотрено.'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "СписокДепонентов");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Депонированные суммы с датами депонирования и остатком невыплаченных сумм.'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "КнигаУчетаДепонентов");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Книга аналитического учета депонированной заработной платы, денежного довольствия и стипендий.'");
		
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Форма0504048");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Книга аналитического учета депонированной заработной платы, денежного довольствия и стипендий (форма 0504048).'");
		
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти
	
#КонецЕсли