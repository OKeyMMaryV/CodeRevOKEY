
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("НастройкаОтчета", ПараметрКоманды);
	ОткрытьФорму("Отчет.бит_ПроизвольныйОтчет.Форма"
									, ПараметрыФормы
									, ПараметрыВыполненияКоманды.Источник
									, ПараметрыВыполненияКоманды.Уникальность
									, ПараметрыВыполненияКоманды.Окно);	
	
КонецПроцедуры // ОбработкаКоманды()

#КонецОбласти